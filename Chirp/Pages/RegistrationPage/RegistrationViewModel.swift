//
//  RegistrationViewModel.swift
//  Chirp
//
//  Created by Stepan Kukharskyi on 6/9/23.
//

import UIKit
import Combine
import FirebaseAuth

class RegistrationViewModel {
    
    private var phoneNumber: String
    private var imageExtension: String = "jpg"
    
    private let service = NetworkService.shared
    private var cancellables: Set<AnyCancellable> = []
    var didRegisterUser = PassthroughSubject<Bool,Never>()
    
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
    }
    
    
    func createAccount(name: String, profileImage: UIImage?) {
        guard let userID = Auth.auth().currentUser?.uid else {
            AlertToast.showAlert(message: AppError.registrationFailed.errorDescription ?? "Error", type: .error)
            return
        }
        
        LoaderView.shared.show(message: "Creating Account...")
        // try saving image first
        if let image = profileImage, let imageData = image.jpegData(compressionQuality: 0.8) {
            let request = UploadProfileImageRequest(userID: userID, imageData: imageData,
                                                               imageExtension: imageExtension,
                                                               timestamp: Date().getCurrentTimestamp())
            service.uploadProfileImage(request: request)
                .sink { response in
                switch response {
                case .failure(let error):
                    AlertToast.showAlert(message: error.localizedDescription, type: .error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] url in
                // create user with profile image
                self?.createUser(userID: userID, name: name, profileImageURL: url.absoluteString)
            }
            .store(in: &cancellables)
        } else {
            // create user without profile image
            createUser(userID: userID, name: name, profileImageURL: "")
        }
    }
    
    
    private func createUser(userID: String, name: String, profileImageURL: String?) {
        let request = CreateUserRequest(userID: userID, name: name,
                                        phoneNumber: phoneNumber,
                                        profilePicture: profileImageURL)
        
        self.service.createUser(request: request)
            .sink { response in
                switch response {
                case .failure(let error):
                    AlertToast.showAlert(message: error.localizedDescription, type: .error)
                    LoaderView.shared.hide()
                case .finished:
                    break
                }
            } receiveValue: { [weak self] user in
                UserDefaults.standard.currentUser = user
                self?.didRegisterUser.send(true)
                LoaderView.shared.hide()
            }
            .store(in: &cancellables)
    }
}
