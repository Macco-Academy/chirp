//
//  PushNotificationService.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 11.06.23.
//

import Foundation
import Combine

class PushNotificationService {
    private let serverKeyID = "FIREBASE_SERVER_KEY"
    static let shared = PushNotificationService()
    
    private let serverKey: String?
    
    init() {
        self.serverKey = Bundle.main.infoDictionary?[serverKeyID] as? String
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    func sendPushNotification(to userId: String, body: String) {
        let request = GetUserRequest(userId: userId)
        NetworkService.shared.getUserData(request: request)
            .sink(receiveCompletion: { response in
                switch response {
                case .failure(_):
                    break
                default:
                    break
                }
            }, receiveValue: { [weak self] user in
                guard let self = self else { return }
                if let user = user,
                   let token = user.fcmToken {
                    self.sendMessageToUser(token: token,
                                           title: "\(user.name ?? "") sent a new message",
                                           message: body)
                }
            })
            .store(in: &cancellables)
    }
    
    private func sendMessageToUser(token: String, title: String, message: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let param: [String: Any] = [
            "to": token,
            "notification": [
                "title": title,
                "body": message,
                "badge": 1,
                "sound": "default"
            ]
        ]
        
        guard let serverKey = serverKey else { return }
        print("Sending:/......", param)
        var request = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request)
        task.resume()
    }
}
