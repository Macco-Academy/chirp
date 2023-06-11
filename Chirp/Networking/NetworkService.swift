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
    case users, chats
}

private enum Key: String {
    case name, phoneNumber, profilePicture, id, timestamp, fcmToken, isContributor, members
}

private enum Collection: String {
    case images, messages
}

struct NetworkService {
    static let shared = NetworkService()
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
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
    
    func getAllUsers(request: GetAllUsersRequest) -> AnyPublisher<[User], Error> {
        Deferred {
            Future { promise in
                db.collection(Table.users.rawValue)
                    .getDocuments(completion: { snapshot, error in
                        if let error = error {
                            promise(.failure(error))
                        } else if let data = snapshot?.documents, let users = data.decode(to: [User].self){
                            promise(.success(users))
                        } else {
                            promise(.success([]))
                        }
                })
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func createUser(request: CreateUserRequest) -> AnyPublisher<User, Error> {
        Deferred {
            Future { promise in
                db.collection(Table.users.rawValue).document(request.userID).setData([
                    Key.id.rawValue: request.userID,
                    Key.name.rawValue: request.name,
                    Key.phoneNumber.rawValue: request.phoneNumber,
                    Key.profilePicture.rawValue: request.profilePicture ?? ""
                ]) { error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    
                    let user = User(id: request.userID, name: request.name,
                                    phoneNumber: request.phoneNumber,
                                    profilePicture: request.profilePicture)
                    promise(.success(user))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func getContributors(request: GetContributorsRequest) -> AnyPublisher<[User], Error> {
        Deferred {
            Future { promise in
                db.collection(Table.users.rawValue)
                    .whereField(Key.isContributor.rawValue, isEqualTo: true)
                    .getDocuments(completion: { snapshot, error in
                        if let error = error {
                            promise(.failure(error))
                        } else if let data = snapshot?.documents, let users = data.decode(to: [User].self){
                            promise(.success(users))
                        } else {
                            promise(.success([]))
                        }
                    })
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
                        return
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
    
    func fetchMessages(request: FetchMessagesRequest) -> AnyPublisher<[Message], Error> {
        let promise = PassthroughSubject<[Message], Error>()
        db
            .collection(Table.chats.rawValue)
            .document(request.id)
            .collection(Collection.messages.rawValue)
            .order(by: Key.timestamp.rawValue)
            .addSnapshotListener({ snapshot, error in
                if let error = error {
                    promise.send(completion: .failure(error))
                } else {
                    if let data = snapshot?.documents,
                       let messages = data.decode(to: [Message].self) {
                        promise.send(messages)
                    } else {
                        promise.send([])
                    }
                    
                }
            })
        return promise.eraseToAnyPublisher()
    }
    
    func createNewChat(request: CreateNewChatRequest) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { promise in
                db
                    .collection(Table.chats.rawValue)
                    .document(request.id)
                    .updateData(request.asDictionary)
                promise(.success(true))
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func updateFCMToken(request: UpdateFCMTokenRequest) {
        guard let uid = auth.currentUser?.uid else { return }
        db
            .collection(Table.users.rawValue)
            .document(uid)
            .updateData([Key.fcmToken.rawValue: request.token])
    }
    
    func getUserChats(request: GetUserChatsRequest) -> AnyPublisher<[RecentChatResponse], Error> {
        let promise = PassthroughSubject<[RecentChatResponse], Error>()
        
        db.collection(Table.chats.rawValue)
            .order(by: Key.timestamp.rawValue, descending: false)
            .whereField(Key.members.rawValue, arrayContains: request.userID)
            .addSnapshotListener({ snapshot, error in
                if let error = error {
                    promise.send(completion: .failure(error))
                    return
                }
                
                let response = snapshot?.documents.decode(to: [RecentChatResponse].self)
                promise.send(response ?? [])
            })
        
        return promise.eraseToAnyPublisher()
    }
    
    func fetchChatBy(id: String) -> AnyPublisher<ChatResponse?, Error> {
        Deferred {
            Future { promise in
                db
                    .collection(Table.chats.rawValue)
                    .document(id)
                    .getDocument(completion: { document, error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            if let data = document?.data() {
                                guard let chat = data.decode(to: ChatResponse?.self) else {
                                    promise(.failure(AppError.errorDecoding))
                                    return
                                }
                                promise(.success(chat))
                            } else {
                                promise(.success(nil))
                            }
                        }
                    })
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func sendMessage(request: SendMessageRequest) -> AnyPublisher<Bool, Error> {
        Deferred {
            Future { promise in
                db
                    .collection(Table.chats.rawValue)
                    .document(request.chatId ?? "")
                    .collection(Collection.messages.rawValue)
                    .addDocument(data: request.asDictionary) { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(true))
                        }
                    }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func updateLastMessage(request: UpdateLastMessageRequest) {
        db
            .collection(Table.chats.rawValue)
            .document(request.lastMessage.chatId ?? "")
            .updateData(request.asDictionary)
    }
}

