//
//  ContactsViewController.swift
//  Chirp
//
//  Created by Uzoh Okwara on 07/06/2023.
//

import UIKit
import Combine

class ContactsViewController: UIViewController {
    
    var type: `Type` = .contact
    private let viewModel = ContactsViewModel()
    private var cancelables: Set<AnyCancellable> = []
    
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
        navigationController?.navigationBar.prefersLargeTitles = true
        setupListeners()
        viewModel.fetchAllUsers()
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
    
    private func setupListeners(){
        viewModel.tableData.sink { [weak self] _ in
            self?.tableView.reloadData()
        }
        .store(in: &cancelables)
    }
    

}

extension ContactsViewController :UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableData.value[section].data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.tableData.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = viewModel.tableData.value[indexPath.section].data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactsTableViewCell.id, for: indexPath) as! ContactsTableViewCell
        
        cell.setup(with: data)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20))
        header.backgroundColor = .systemGroupedBackground
        let title = UILabel(frame: CGRect(x: 20, y: 5, width: 20, height: 20))
        title.textColor = .label
        title.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        guard viewModel.tableData.value.count > section else {return header}
        title.text = viewModel.tableData.value[section].sectionName
        header.addSubview(title)
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = viewModel.tableData.value[indexPath.section].data[indexPath.row]
        
    }
}

extension ContactsViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchQuery = searchController.searchBar.text ?? ""
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.searchIsActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        viewModel.searchIsActive = false
    }
    
}
