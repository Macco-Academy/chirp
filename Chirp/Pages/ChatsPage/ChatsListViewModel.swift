//
//  ChatsListViewModel.swift
//  Chirp
//
//  Created by Ady on 6/8/23.
//

import Foundation
import Combine

class ChatsListViewModel {

    var searchQuery = "" {
        didSet { updateSearchResults() }
    }

    private var fullList = [ChatViewModel]()
    private var displayList = [ChatViewModel]()

    private let service = NetworkService.shared
    private var cancellables: Set<AnyCancellable> = []

    var chatsFiltered = PassthroughSubject<Bool, Never>()
    var newChatsFetched = PassthroughSubject<Bool, Never>()

    func numberOfRows() -> Int {
        return displayList.count
    }

    func model(at index: Int) -> ChatViewModel {
        return displayList[index]
    }

    // Search
    private func updateSearchResults() {
        guard !searchQuery.isEmpty else {
            displayList = fullList
            chatsFiltered.send(true)
            return
        }
        
        displayList = fullList.filter {
            $0.title?.lowercased().contains(searchQuery.lowercased()) ?? false
        }
        
        chatsFiltered.send(true)
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

        fullList = []
        displayList = []
        var requestCounter = 0
        let maxCount = (min(10, responses.count))

        responses.forEach { response in
            guard let memberIDs = response.members,
                    memberIDs.count == 2 else { return }
            
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
                    
                    if !response.lastMessage.isEmpty {
                        self?.fullList.append(ChatViewModel(chat: recentChat))
                    }
                    
                    if requestCounter == maxCount {
                        self?.displayList = self?.fullList ?? []
                        self?.newChatsFetched.send(true)
                    }
                }
                .store(in: &cancellables)
            }
        }
    }
}
