//
//  LoginViewModel.swift
//  Chirp
//
//  Created by ioannis on 10/6/23.
//

import Foundation
import Combine
import FirebaseAuth

class OTPViewModel {
    
    private let service = NetworkService.shared
    private var cancellables: Set<AnyCancellable> = []
    var foundUser = PassthroughSubject<Bool,Never>()
    
    func verifyOTP(code:String) {
        LoaderView.shared.show(message: "Verifying Code....")
        let request = VerifyOPTRequest(verificationId: UserDefaults.standard.otpVerificationID ?? "", verificationCode: code)
        service.verifyPhoneNumberWithCode(request: request)
            .sink { response in
                switch response {
                case .finished:
                    break
                case .failure(let error):
                    AlertToast.showAlert(message: error.localizedDescription, type: .error)
                    LoaderView.shared.hide()
                }
            } receiveValue: { [weak self] _ in
                self?.getUserDetails()
            }
            .store(in: &cancellables)
    }
    
    func getUserDetails() {
        guard let userID = Auth.auth().currentUser?.uid else {return}
        let request = GetUserRequest(userId: userID)
        service.getUserData(request: request)
            .sink { response in
                switch response {
                case .finished:
                    break
                case .failure(let error):
                    AlertToast.showAlert(message: error.localizedDescription, type: .error)
                    LoaderView.shared.hide()
                }
            } receiveValue: { [weak self] user in
                UserDefaults.standard.currentUser = user
                self?.foundUser.send(user != nil)
                LoaderView.shared.hide()
            }
            .store(in: &cancellables)
    }
}
