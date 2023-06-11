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
        // TODO: Fetch chat details using ID
        // This will be used to get information about chat including member's fcmToken, and unreadCount
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
        let request = SendMessageRequest(chatId: chatId, message: text)
        service.sendMessage(request: request)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    AlertToast.showAlert(message: error.localizedDescription, type: .error)
                case .finished:
                    // Message sent successfully
                    // Update the recent messages with the last message sent
                    break
                }
            } receiveValue: { message in
                // Handle the sent message if needed
            }
            .store(in: &cancellables)
    }
}

