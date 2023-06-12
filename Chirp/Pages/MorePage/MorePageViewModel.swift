//
//  MorePageViewModel.swift
//  Chirp
//
//  Created by Ady on 6/11/23.
//

import Foundation
import Combine

class MorePageViewModel {
    private let service = NetworkService.shared
    private var cancellables: Set<AnyCancellable> = []
    var logoutSuccessful = PassthroughSubject<Bool,Never>()
    var deleteSuccessful = PassthroughSubject<Bool, Never>()
    
    func logoutUser() {
        LoaderView.shared.show(message: "Logging Out...")
        service.logout().sink { response in
            switch response {
            case .failure(let error):
                AlertToast.showAlert(message: error.localizedDescription, type: .error)
                LoaderView.shared.hide()
            case .finished:
                break
            }
        } receiveValue: { [weak self] _ in
            UserDefaults.standard.currentUser = nil
            self?.logoutSuccessful.send(true)
            LoaderView.shared.hide()
        }.store(in: &cancellables)
    }
    
    func deleteUser(userID: String) {
        let request = DeleteUserRequest(userID: userID)
        LoaderView.shared.show(message: "Deleting Account...")
        service.deleteUser(request: request).sink { response in
            switch response {
            case .failure(let error):
                AlertToast.showAlert(message: error.localizedDescription, type: .error)
                LoaderView.shared.hide()
            case .finished:
                break
            }
        } receiveValue: { [weak self] _ in
            LoaderView.shared.hide()
            UserDefaults.standard.currentUser = nil
            self?.deleteSuccessful.send(true)
        }.store(in: &cancellables)
    }
}
