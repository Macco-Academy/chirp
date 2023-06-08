//
//  ContactsViewController.swift
//  Chirp
//
//  Created by Uzoh Okwara on 07/06/2023.
//

import UIKit

class ContactsViewController: UIViewController {
    
    private var fullData = [Contacts]()
    private var tableData = [Contacts]()
    var type: `Type` = .contact
    
    
    enum `Type` {
        case contact, contributors
        
        var pageName: String {
            switch self {
            case .contact:
                return "Contacts"
            case .contributors:
                return "Contributors"
            }
        }
    }

    
    var searchController: UISearchController = {
             let searchController = UISearchController(searchResultsController: nil)
             searchController.searchBar.placeholder = "Search"
             return searchController
         }()
    
    let tableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = UIColor.systemBackground
        tableview.separatorStyle = .singleLine
        tableview.showsVerticalScrollIndicator = false
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(ContactsTableViewCell.self, forCellReuseIdentifier: ContactsTableViewCell.id)
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = type.pageName
        view.backgroundColor = UIColor.systemBackground
        setupViews()
        setupSearchBar()
        fullData = setupTableData()
        tableData = fullData
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func setupSearchBar() {
             searchController.searchResultsUpdater = self
             navigationItem.searchController = searchController
         }
    
    func setupTableData() -> [Contacts] {
        let unsortedData = [
            ContactsDetails(image: UIImage.infoCircleFill, text: "Arlene McCoy"),
            ContactsDetails(image: UIImage.infoCircleFill, text: "Avon Lane"),
            ContactsDetails(image: UIImage.infoCircleFill, text: "Ben Dark"), ContactsDetails(image: UIImage.infoCircleFill, text: "Bishop Pope"),
            ContactsDetails(image: UIImage.infoCircleFill, text: "Aessie Cooper"),
            ContactsDetails(image: UIImage.infoCircleFill, text: "Cardless King"),
            ContactsDetails(image: UIImage.infoCircleFill, text: "Card Boy"),
            ContactsDetails(image: UIImage.infoCircleFill, text: "Mike Boy")
        ]
        
        var grouped: [String: [ContactsDetails]] = [:]
        unsortedData.forEach {
            let key = "\(String(describing: $0.text.first))"
            var users = grouped[key] ?? []
            users.append($0)
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
    
    
}

extension ContactsViewController :UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = tableData[indexPath.section].data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.id, for: indexPath) as! ContactsTableViewCell
        
        cell.setup(with: data)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        header.backgroundColor = .systemGroupedBackground
        let title = UILabel(frame: CGRect(x: 20, y: 5, width: 20, height: 20))
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        guard tableData.count > section else {return header}
        title.text = tableData[section].sectionName
        header.addSubview(title)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = tableData[indexPath.section].data[indexPath.row]
        
    }
}

extension ContactsViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        updateSearchResult()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        updateSearchResult()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        updateSearchResult()
    }
    
    private func updateSearchResult() {
        guard let search = searchController.searchBar.searchTextField.text,
        !search.isEmpty else {
            self.tableData = fullData
            tableView.reloadData()
            return
        }
        tableData = fullData.filter {
            $0.data.first?.text.lowercased().contains(search.lowercased()) ?? false
        }
        tableData = []
        fullData.forEach { section in
            let filteredList = section.data.filter {
                $0.text.lowercased().contains(search.lowercased())
            }
            if !filteredList.isEmpty {
                tableData.append(Contacts(sectionName: section.sectionName, data: filteredList))
            }
        }
        tableView.reloadData()
    }
}
