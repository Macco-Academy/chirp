//
//  RegistrationViewModel.swift
//  Chirp
//
//  Created by Stepan Kukharskyi on 6/9/23.
//

import UIKit

class RegistrationViewModel {
    
    var userID: String
    var phoneNumber: String
    
    // Init
    init(userID: String, phoneNumber: String) {
        self.userID = userID
        self.phoneNumber = phoneNumber
    }
    
    // Functionality
    func createUser(name: String, profileImage: UIImage?) {
        
    }
    
    private func saveUserImage(_ image: UIImage?) {
        guard let image = image else { return }
        
        StorageService.shared.uploadProfileImage(userID: userID, image: image)
    }
    

}
