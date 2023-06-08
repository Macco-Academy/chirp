//
//  ChatsViewController.swift
//  Chirp
//
//  Created by Ady on 6/7/23.
//

import UIKit

class ChatsViewController: UIViewController {
    
    var chatsTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = true
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarTitle()
        setupSearchBar()
        setupViews()
        setupConstraints()
    }
    
    private func setupNavigationBarTitle() {
        title = "Chats"
        navigationController?.navigationBar.prefersLargeTitles = true
        // TODO: Check if this is not needed
        navigationItem.hidesBackButton = true
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
    
    private func setupViews() {
        view.addSubview(chatsTableView)
        chatsTableView.dataSource = self
        chatsTableView.delegate = self
        chatsTableView.register(ChatsTableViewCell.self, forCellReuseIdentifier: ChatsTableViewCell.identifier)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            chatsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            chatsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension ChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Update when we have actual data
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatsTableViewCell.identifier, for: indexPath) as! ChatsTableViewCell
        cell.setup()
        // TODO: Update when we have actual data
        cell.friendImageView.image = UIImage(named: "nophoto")
        return cell
    }
}

extension ChatsViewController: UITableViewDelegate {
    
}

extension ChatsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchBar.searchTextField.text else { return }
        // TODO: Update this
        print(search)
    }
}
