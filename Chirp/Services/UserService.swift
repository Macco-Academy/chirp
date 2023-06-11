//
//  UserService.swift
//  Chirp
//
//  Created by Stepan Kukharskyi on 6/9/23.
//

import Foundation
import Firebase

class UserService {
    
    static let shared = UserService()
    
    private let database = Firestore.firestore()
    private let collection = "users"
    
    private let nameKey = "name"
    private let phoneNumberKey = "phoneNumber"
    private let profileImageURLKey = "profileImageURL"
    
    
    func createUser(_ user: User) {
         //TODO: Get user uid after authentication
        let userId = UUID().uuidString // temporary solution
        database.collection(collection).document(userId).setData([
            nameKey: user.name,
            phoneNumberKey: user.phoneNumber,
            profileImageURLKey: user.profilePicture ?? ""
        ]) { error in
            guard error == nil else {
                print(error!)
                return
            }
            
            print("User succesfully saved")
        }
    }
}
