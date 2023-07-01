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
    private var chat: ChatResponse?
    
    private var cancellables: Set<AnyCancellable> = []
    var messages = CurrentValueSubject<[MessageCellViewModel], Never>([])
    var oppositeUserTyping = CurrentValueSubject<Bool, Never>(false)
    let recipientName: String
    
    var numberOfRows: Int {
        return oppositeUserTyping.value ? (messages.value.count + 1) : messages.value.count
    }
    
    init(chatId: String, recipientName: String) {
        self.chatId = chatId
        self.recipientName = recipientName
        fetchChatById()
    }
    
    private func fetchChatById() {
        service.fetchChatBy(id: chatId)
            .sink { response in
                switch response {
                case .failure(let error):
                    print(error.localizedDescription)
                default: break
                }
            } receiveValue: { chatResponse in
                guard let chatResponse = chatResponse else { return }
                self.chat = chatResponse
                self.checkIfOppositeUserIsTyping()
            }
            .store(in: &cancellables)
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
        let request = SendMessageRequest(id: UUID().uuidString,
                                         chatId: chatId,
                                         senderId: UserDefaults.standard.currentUser?.id,
                                         message: text,
                                         type: .text)
        service.sendMessage(request: request)
            .sink { response in
                switch response {
                case .failure(let error):
                    print(error.localizedDescription)
                default: break
                }
            } receiveValue: { _ in
                self.updateRecentMessage(message: request)
                let receiverId = self.chat?.members?.first { $0 != UserDefaults.standard.currentUser?.id } ?? ""
                PushNotificationService.shared.sendPushNotification(to: receiverId, body: text)
            }
            .store(in: &cancellables)
    }
    
    private func updateRecentMessage(message: SendMessageRequest) {
        var unreadCount = chat?.unreadCount ?? [:]
        if let receiverId = chat?.members?.first(where: { $0 != UserDefaults.standard.currentUser?.id }) {
            unreadCount[receiverId] = (unreadCount[receiverId] ?? 0) + 1
        }
        chat?.unreadCount = unreadCount
        
        let request = UpdateLastMessageRequest(lastMessage: message, unreadCount: unreadCount)
        service.updateLastMessage(request: request)
    }
    
    func resetUnreadCount() {
        var unreadCount = chat?.unreadCount ?? [:]
        if let myId = chat?.members?.first(where: { $0 == UserDefaults.standard.currentUser?.id }) {
            unreadCount[myId] = 0
        }
        chat?.unreadCount = unreadCount
        
        let request = ResetUnreadCountRequest(id: chatId, unreadCount: unreadCount)
        service.resetUnreadCount(request: request)
    }
    
    func updateMyTypingStatus(to isTyping: Bool) {
        var typingStatus = chat?.typingStatus ?? [:]
        if let myID = chat?.members?.first(where: { $0 == UserDefaults.standard.currentUser?.id }) {
            typingStatus[myID] = isTyping
        }
        
        let request = UpdateTypingStatusRequest(id: chatId, typingStatus: typingStatus)
        service.updateTypingStatus(request: request)
    }
    
    func checkIfOppositeUserIsTyping() {
        var isTyping = false
        if let oppositeUserID = chat?.members?.first(where: { $0 != UserDefaults.standard.currentUser?.id }) {
            isTyping = chat?.typingStatus?[oppositeUserID] ?? false
        }
        oppositeUserTyping.send(isTyping)
    }
}

