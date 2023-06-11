//
//  ChatsViewController.swift
//  Chirp
//
//  Created by Ady on 6/7/23.
//

import UIKit

// TODO: Remove
let dummyData: [RecentChat] = [
    RecentChat(id: "123", members: [User(id: "user1", name: "Tony", profilePicture: ""), User(id: "user2", name: "James", profilePicture: "")], lastMessage: Message(senderId: "user1", message: "abucdefg", timeStamp: Date()), unreadCount: ["user1": 2]),
    RecentChat(id: "123", members: [User(id: "user1", name: "Tony", profilePicture: ""), User(id: "user2", name: "Heidi Tom", profilePicture: "")], lastMessage: Message(senderId: "user1", message: "abucdefg", timeStamp: Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!)!), unreadCount: ["user1": 2]),
    RecentChat(id: "123", members: [User(id: "user1",name: "Tony", profilePicture: ""), User(id: "user2",name: "Tom Hanks", profilePicture: "")], lastMessage: Message(senderId: "user1", message: "abucdefg", timeStamp: Date()), unreadCount: ["user1": 1232]),
    RecentChat(id: "123", members: [User(id: "user1",name: "Tony", profilePicture: ""), User(id: "user2",name: "emmanuel this is a long name and to check it", profilePicture: "")], lastMessage: Message(senderId: "user1", message: "abucdefg", timeStamp: Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!)!), unreadCount: ["user1": 0])
]

class ChatsViewController: UIViewController {
    
    let fullList: [ChatsListViewModel] = dummyData.map {$0.asChatListViewModel}
    
    var list: [ChatsListViewModel] = []
    
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
        self.list = fullList
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
}

extension ChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatsTableViewCell.identifier, for: indexPath) as! ChatsTableViewCell
        cell.setup(viewModel: list[indexPath.row])
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
        guard let search = searchController.searchBar.searchTextField.text,
              !search.isEmpty else {
            self.list = fullList
            chatsTableView.reloadData()
            return
        }
        list = fullList.filter {
            $0.title?.lowercased().contains(search.lowercased()) ?? false
        }
        chatsTableView.reloadData()
    }
    
}
