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

    private var displayList = [ChatViewModel]()
    private var fullList = [ChatViewModel]()
    
    private let service = NetworkService.shared
    private var cancellables: Set<AnyCancellable> = []

    var chatsFiltered = PassthroughSubject<Bool, Never>()

    func numberOfRows() -> Int {
        return displayList.count
    }

    func model(at index: Int) -> ChatViewModel? {
        return index < displayList.count ? displayList[index] : nil
    }

    
    // Get Chats Response
    func getRecentChats() {
        guard let userID = UserDefaults.standard.currentUser?.id else {
            AlertToast.showAlert(message: AppError.chatsError.localizedDescription, type: .error)
            return
        }

        LoaderView.shared.show(message: "Fetching chats...")
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
    private func createChats(from responses: [ChatResponse]) {
        guard !responses.isEmpty else {
            LoaderView.shared.hide()
            return
        }

        var requestCounter = 0
        let maxCount = (min(10, responses.count))

        responses.forEach { response in
            guard let memberIDs = response.members, memberIDs.count == 2 else { return }
            guard let message = response.lastMessage?.message, !message.isEmpty else { return }
            guard let currentUser = UserDefaults.standard.currentUser,
                  let senderID = memberIDs.filter({ $0 != currentUser.id }).first else { return }
            
            requestCounter += 1
            let request = GetUserRequest(userId: senderID)
            service.getUserData(request: request).sink { userResponse in
                switch userResponse {
                case .finished:
                    break
                case .failure(let error):
                    AlertToast.showAlert(message: error.localizedDescription, type: .error)
                }
            } receiveValue: { [weak self] user in
                let sender = user ?? User(id: senderID)
                let chatMembers = [currentUser, sender]
                let chat = RecentChat(id: response.id, members: chatMembers,
                                            lastMessage: response.lastMessage,
                                            unreadCount: response.unreadCount)
                let chatViewModel = ChatViewModel(chat: chat)
                self?.appendAndSortChatVM(chatViewModel)
                
                if requestCounter >= maxCount {
                    LoaderView.shared.hide()
                    self?.updateSearchResults()
                }
            }
            .store(in: &cancellables)
        }
    }
    
    // Append+Sort
    private func appendAndSortChatVM(_ chatVM: ChatViewModel) {
        if let existingChatIndex = fullList.firstIndex(where: { $0.chatID == chatVM.chatID }) {
            if fullList[existingChatIndex].lastMessage?.id != chatVM.lastMessage?.id {
                fullList[existingChatIndex] = chatVM
            }
        } else {
            fullList.append(chatVM)
        }
        
        fullList.sort(by: { ($0.timestamp ?? Date.distantPast) > ($1.timestamp ?? Date.distantPast) })
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
}
