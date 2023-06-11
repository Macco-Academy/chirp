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
    
    func fetchMessages() {
        let request = FetchMessagesRequest(id: chatId)
        service.fetchMessages(request: request)
            .sink { response in
                switch response {
                case .failure(let error):
                    AlertToast.showAlert(message: error.localizedDescription, type: .error)
                default:
                    break
                }
            } receiveValue: { messages in
                self.messages.send(messages.map { $0.asMessageCellViewModel })
            }
            .store(in: &cancellables)
    }
    
    func sendMessage(_ text: String) {
        // TODO: Implement code to send message to user
        
        // TODO: Send push notification after message has sent successfully
        
        // TODO: Update the recent messages with the last message sent
    }
}

