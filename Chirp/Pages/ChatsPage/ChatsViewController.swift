//
//  ChatsViewController.swift
//  Chirp
//
//  Created by Ady on 6/7/23.
//

import UIKit
import Combine

class ChatsViewController: UIViewController {
    
    private let viewModel = ChatsListViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
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
        setupListeners()
        viewModel.getRecentChats()
    }
    
    private func setupNavigationBarTitle() {
        title = "Chats"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
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
    
    private func setupListeners() {
        viewModel.newChatsFetched.sink { [weak self] newChatsLoaded in
            if newChatsLoaded {
                self?.chatsTableView.reloadData()
            }
        }.store(in: &cancellables)
        
        viewModel.chatsFiltered.sink { [weak self] chatsFiltered in
            if chatsFiltered {
                self?.chatsTableView.reloadData()
            }
        }.store(in: &cancellables)
    }
}

extension ChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatsTableViewCell.identifier, for: indexPath) as! ChatsTableViewCell
        let model = viewModel.model(at: indexPath.row)
        cell.setup(viewModel: model)
        return cell
    }
}

extension ChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = MessagesViewModel(chatId: "chatId")
        let controller = MessagesViewController(viewModel: viewModel)
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ChatsViewController: UISearchResultsUpdating, UISearchBarDelegate {
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
        if let searchQuery = searchController.searchBar.searchTextField.text {
            viewModel.searchQuery = searchQuery
        }
    }
}
