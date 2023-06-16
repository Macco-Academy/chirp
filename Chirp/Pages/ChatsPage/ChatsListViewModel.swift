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
        service.getUserChats(request: request)
            .sink { response in
                switch response {
                case .failure(let error):
                    print(error.localizedDescription)
                default: break
                }
            } receiveValue: { chatsResponse in
                guard !chatsResponse.isEmpty else {
                    LoaderView.shared.hide()
                    return
                }
                let usersToPopulate = Set(chatsResponse.map { $0.members ?? [] }).joined().map { $0 }
                self.fetchUsersByIds(ids: usersToPopulate, chatResponse: chatsResponse)
            }
            .store(in: &cancellables)
    }

    private func fetchUsersByIds(ids: [String], chatResponse: [ChatResponse]) {
        let request = GetSpecificUsersRequest(userIds: ids)
        self.service.fetchUsersByIds(request: request)
            .sink { res in } receiveValue: { users in
                let chats = chatResponse.map { chatResponse in
                    let members = chatResponse.members?.map { memberId in
                        users.first { $0.id! ==  memberId}
                    }.compactMap({ $0 })
                    return ChatViewModel(chat: RecentChat(id: chatResponse.id,
                                                          members: members,
                                                          lastMessage: chatResponse.lastMessage,
                                                          unreadCount: chatResponse.unreadCount))
                }
                
                self.fullList = chats.sorted(by: { $0.lastMessage?.timestamp ?? Date() > $1.lastMessage?.timestamp ?? Date() })
                self.updateSearchResults()
                LoaderView.shared.hide()
            }
            .store(in: &self.cancellables)
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
