//
//  ChatsListViewModel.swift
//  Chirp
//
//  Created by Ady on 6/8/23.
//

import Foundation
import Combine

class ChatsListViewModel {

    var searchQuery = ""

    private var chatViewModels = [ChatViewModel]()
    private var filteredViewModels = [ChatViewModel]()

    private let service = NetworkService.shared
    private var cancellables: Set<AnyCancellable> = []

    var chatsFiltered = PassthroughSubject<Bool, Never>()
    var newChatsFetched = PassthroughSubject<Bool, Never>()

    func numberOfRows() -> Int {
        return chatViewModels.count
    }

    func model(at index: Int) -> ChatViewModel {
        return chatViewModels[index]
    }

    // Get Chats Response
    func getRecentChats() {
        guard let userID = UserDefaults.standard.currentUser?.id else {
            AlertToast.showAlert(message: AppError.chatsError.localizedDescription, type: .error)
            return
        }

        let request = GetUserChatsRequest(userID: userID)
        service.getUserChats(request: request).sink { response in
            switch response {
            case .failure(let error):
                AlertToast.showAlert(message: error.localizedDescription, type: .error)
            case .finished:
                break
            }
        } receiveValue: { [weak self] chatsResponses in
            self?.createChats(from: chatsResponses)
        }
        .store(in: &cancellables)
    }

    
    
    // Create Chat objects from response
    private func createChats(from responses: [RecentChatResponse]) {
        guard !responses.isEmpty else { return }

        var requestCounter = 0
        let maxCount = (min(10, responses.count))

        responses.forEach { response in
            guard let memberIDs = response.members, memberIDs.count == 2 else { return }
            
            memberIDs.forEach { memberID in
                guard let currentUser = UserDefaults.standard.currentUser,
                          currentUser.id != memberID else { return }
                
                requestCounter += 1
                let request = GetUserRequest(userId: memberID)
                service.getUserData(request: request).sink { userResponse in
                    switch userResponse {
                    case .finished:
                        break
                    case .failure(let error):
                        AlertToast.showAlert(message: error.localizedDescription, type: .error)
                    }
                } receiveValue: { [weak self] user in
                    let chatMembers = [currentUser, user ?? User(id: memberID)]
                    let recentChat = RecentChat(id: response.id,
                                                members: chatMembers,
                                                lastMessage: response.lastMessage,
                                                timestamp: response.timestamp,
                                                unreadCount: response.unreadCount)
                    self?.chatViewModels.append(ChatViewModel(chat: recentChat))
                    
                    if requestCounter == maxCount { self?.newChatsFetched.send(true) }
                }
                .store(in: &cancellables)

            }
        }
    }
}
