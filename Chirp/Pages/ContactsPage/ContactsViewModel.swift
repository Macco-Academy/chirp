//
//  ContactsViewModel.swift
//  Chirp
//
//  Created by Siarhei Anoshka on 10.06.23.
//

import Foundation
import Combine

class ContactsViewModel {
    
    private let service = NetworkService.shared
    private var cancellables: Set<AnyCancellable> = []
    var searchIsActive: Bool = false
    var searchQuery: String = "" {
        didSet {
            updateSearchResult()
        }
    }
    
    private var fullData = [Contacts]()
    var tableData = CurrentValueSubject<[Contacts], Never>([])
    
    func fetchAllUsers(){
        LoaderView.shared.show()
        let request = GetAllUsersRequest()
        service.getAllUsers(request: request)
            .sink { response in
                LoaderView.shared.hide()
                switch response {
                case .failure(let error):
                    AlertToast.showAlert(message: error.localizedDescription, type: .error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] users in
                LoaderView.shared.hide()
                self?.fullData = self?.setupTableData(users: users) ?? []
                self?.updateSearchResult()
            }
            .store(in: &cancellables)
    }
    
    func fetchContributors(){
        LoaderView.shared.show()
        let request = GetContributorsRequest()
        service.getContributors(request: request)
            .sink { response in
                LoaderView.shared.hide()
                switch response {
                case .failure(let error):
                    AlertToast.showAlert(message: error.localizedDescription, type: .error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] contributors in
                LoaderView.shared.hide()
                self?.fullData = self?.setupTableData(users: contributors) ?? []
                self?.updateSearchResult()
            }
            .store(in: &cancellables)
    }
    
    private func setupTableData(users: [User]) -> [Contacts] {
        var grouped: [String: [ContactsDetails]] = [:]
        users.forEach {
            let key = "\(String(describing: $0.asContactDetail.text.first))"
            var users = grouped[key] ?? []
            users.append($0.asContactDetail)
            grouped[key] = users
        }
        
        let contacts = grouped.values.map {
            var key = ""
            
            if let firstChar = $0.first?.text.first {
                let firstStr = String(firstChar)
                key = firstStr
            }
            let contact = Contacts(sectionName: key, data: $0)
            return contact
        }
        return contacts.sorted(by: { $0.sectionName < $1.sectionName })
    }
    
    private func updateSearchResult() {
        guard !searchQuery.isEmpty, searchIsActive else {
            self.tableData.send(fullData)
            return
        }
        var filteredData:[Contacts] = []
        fullData.forEach { section in
            let filteredList = section.data.filter {
                $0.text.lowercased().contains(searchQuery.lowercased())
            }
            if !filteredList.isEmpty {
                filteredData.append(Contacts(sectionName: section.sectionName, data: filteredList))
            }
        }
        self.tableData.send(filteredData)
    }
    
}



