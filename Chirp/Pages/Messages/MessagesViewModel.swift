//
//  MessagesViewModel.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 11.06.23.
//

import Combine
import UIKit

class MessagesViewModel {
    private let chatId: String
    private let service = NetworkService.shared
    
    private var cancellables: Set<AnyCancellable> = []
    var messages = CurrentValueSubject<[MessageCellViewModel], Never>([])
    
    init(chatId: String) {
        self.chatId = chatId
        fetchChatById()
    }
    
    private func fetchChatById() {
//        service.fetchChatBy(id: id)
//            .sink { response in
//                switch response {
//                case .failure(let error):
//                    print(error.localizedDescription)
//                default: break
//                }
//            } receiveValue: { chatResponse in
//                guard let chatResponse = chatResponse else { return }
//                self.chat = chatResponse
//            }
//            .store(in: &cancellables)
    }
    
    func fetchMessages() {
        let messages: [MessageCellViewModel] = [
            MessageCellViewModel(chatId: "id", message: "This is a message", timestamp: Date().asTimeAgo, senderId: "thotherperson"),
            MessageCellViewModel(chatId: "id", message: "This is a message", timestamp: Date().asTimeAgo, senderId: "thotherperson"),
            MessageCellViewModel(chatId: "id", message: "This is a message", timestamp: Date().asTimeAgo, senderId: "thotherperson"),
            MessageCellViewModel(chatId: "id", message: "This is a message", timestamp: Date().asTimeAgo, senderId: "thotherperson"),
            MessageCellViewModel(chatId: "id", message: "This is a message", timestamp: Date().asTimeAgo, senderId: "user1"),
            MessageCellViewModel(chatId: "id", message: "This is a message", timestamp: Date().asTimeAgo, senderId: "thotherperson"),
            MessageCellViewModel(chatId: "id", message: "This is a message", timestamp: Date().asTimeAgo, senderId: "user1"),
        ]
        
        self.messages.send(messages)
        
        
//        let request = FetchMessagesRequest(id: id)
//        service.fetchMessages(request: request)
//            .sink { response in
//                switch response {
//                case .failure(let error):
//                    print(error.localizedDescription)
//                default:
//                    print("Finished")
//                }
//            } receiveValue: { messages in
//                self.messages.send(messages)
//            }
//            .store(in: &cancellables)
    }
    
    func sendMessage(_ text: String) {
        // TODO: Implement code to send message to user
        
        // TODO: Send push notification after message has sent successfully
        
        // TODO: Update the recent messages with the last message sent
    }
}

