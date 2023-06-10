//
//  NetworkService.swift
//  Chirp
//
//  Created by ioannis on 10/6/23.
//
import Foundation
import Combine
import Firebase

private enum Table: String {
    case users
}


struct NetworkService {
    static let shared = NetworkService()
    private let db = Firestore.firestore()
    func verifyPhoneNumberWithCode(request:VerifyOPTRequest) -> AnyPublisher<Bool, Error> {
        Deferred{
            Future { promise in
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: request.verificationId, verificationCode: request.verificationCode)
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if let error = error {
                        promise(.failure(error))
                    } else if let authResult = authResult {
                        promise(.success(true))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func getUserData(request:GetUserRequest) ->AnyPublisher<User?,Error> {
        Deferred{
            Future { promise in
                db.collection(Table.users.rawValue)
                    .document(request.userId).getDocument { snapshot, error in
                        if let error = error {
                            promise(.failure(error))
                        } else if let data = snapshot?.data(){
                            if let user = data.decode(to: User.self) {
                                promise(.success(user))

                            } else {
                                
                            }
                            
                        } else {
                            promise(.success(nil))
                        }
                    }
            }
            
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
}

