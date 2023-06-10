//
//  LoginViewModel.swift
//  Chirp
//
//  Created by ioannis on 10/6/23.
//

import Foundation
import Combine

class OTPViewModel {
    
    private let service = NetworkService.shared
    private var cancellables: Set<AnyCancellable> = []
    
    
    func verifyOTP(phone:String) {
        let request = VerifyOPTRequest(verificationId: "", verificationCode: phone)
        service.verifyPhoneNumberWithCode(request: request)
            .sink { response in
                switch response {
                case .finished:
                    break
                case .failure(let error):
                    AlertToast.showAlert(message: error.localizedDescription, type: .error)
                }
            } receiveValue: {[weak self] _ in
                self?.getUserDetails()
            }

            .store(in: &cancellables)
    }
    
    func getUserDetails() {
        
        
    
        
        
    }
    
    
    
    
    
    
    
}
