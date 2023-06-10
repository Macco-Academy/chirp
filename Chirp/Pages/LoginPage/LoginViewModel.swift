//
//  LoginViewModel.swift
//  Chirp
//
//  Created by Kwaku Dapaah on 6/10/23.
//

import Foundation
import Combine

class LoginViewModel {
    private let service = NetworkService.shared
    private var cancellables: Set<AnyCancellable> = []
    var otpSent = PassthroughSubject<Bool, Never>()

    func sendOTP(phoneNumber: String) {
        let request = SendOTPRequest(phoneNumber: phoneNumber)
        service.sendOTPToPhoneNumber(request: request)
            .sink { [weak self] response in
                switch response {
                case .failure(let error):
                    AlertToast.showAlert(message: error.localizedDescription, type: .error)
                    self?.otpSent.send(false)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] verificationID in
                UserDefaults.standard.otpVerificationID = verificationID
                self?.otpSent.send(true)
            }
            .store(in: &cancellables)
        
        
    }
}
