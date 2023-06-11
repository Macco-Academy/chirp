//
//  StorageService.swift
//  Chirp
//
//  Created by Stepan Kukharskyi on 6/9/23.
//

import UIKit
import Combine
import FirebaseStorage

class StorageService {
    
    static let shared = StorageService()
    
    private let storage = Storage.storage()
    private let imagesFolder = "images"
    
    
    // Callback
    func uploadProfileImage(userID: String, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        let imageExtension = "jpg"
        let timestamp = Date().getCurrentTimestamp()
        let fileName = "profileImage_\(userID)_\(timestamp).\(imageExtension)"

        let storageRef = Storage.storage().reference()
        let imagesFolderRef = storageRef.child(imagesFolder)
        let imageRef = imagesFolderRef.child(fileName)

        imageRef.putData(imageData) { metadata, error in
            guard let metadata = metadata else {
                //Error
                return
            }

            imageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    //Error
                    return
                }
                
                print(downloadURL)
            }
        }
    }
}
