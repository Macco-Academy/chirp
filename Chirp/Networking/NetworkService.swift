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

private enum Key: String {
    case name, phoneNumber, profilePicture
}

private enum Collection: String {
    case images
}

struct NetworkService {
    static let shared = NetworkService()
    private let db = Firestore.firestore()
    
    func sendOTPToPhoneNumber(request: SendOTPRequest )  -> AnyPublisher<String?, Error> {
        Deferred{
            Future { promise in
                PhoneAuthProvider.provider()
                    .verifyPhoneNumber(request.phoneNumber, uiDelegate: nil) { verificationID, error in
                        if let error = error {
                            promise(.failure(error))
                            return
                        }
                        promise(.success(verificationID))
                    }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
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
    
    func createUser(request: CreateUserRequest) -> AnyPublisher<User, Error> {
        Deferred {
            Future { promise in
                db.collection(Table.users.rawValue).document(request.userID).setData([
                    Key.name.rawValue: request.name,
                    Key.phoneNumber.rawValue: request.phoneNumber,
                    Key.profilePicture.rawValue: request.profilePicture ?? ""
                ]) { error in
                    if let error = error {
                        promise(.failure(error))
                    }
                    
                    let user = User(id: request.userID,
                                    name: request.name,
                                    phoneNumber: request.phoneNumber,
                                    profilePicture: request.profilePicture)
                    promise(.success(user))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func uploadProfileImage(request: UploadProfileImageRequest) -> AnyPublisher<URL, Error> {
        Deferred {
            Future { promise in
                
                let storageRef = Storage.storage().reference()
                let imagesCollectionRef = storageRef.child(Collection.images.rawValue)
                let fileName = "profileImage_\(request.userID)_\(request.timestamp).\(request.imageExtension)"
                let imageRef = imagesCollectionRef.child(fileName)
                
                imageRef.putData(request.imageData) { metadata, error in
                    if let error = error {
                        promise(.failure(error))
                    }
                    
                    imageRef.downloadURL { url, error in
                        guard let url = url else {
                            promise(.failure(error ?? AppError.imageUploadFailed))
                            return
                        }
                        
                        promise(.success(url))
                    }
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}

