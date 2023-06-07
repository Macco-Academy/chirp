//
//  ChatViewController.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 07.06.23.
//

import UIKit

class ChatViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private var messages: [Message] = [
        .init(id: "1", message: "Hello", senderId: "user1"),
        .init(id: "1", message: "Hello", senderId: "user2"),
        .init(id: "1", message: "Hello", senderId: "user1"),
        .init(id: "1", message: "Hello", senderId: "user2"),
        .init(id: "1", message: "Hello", senderId: "user1"),
        .init(id: "1", message: "Hello", senderId: "user2"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReceiverTableViewCell.self, forCellReuseIdentifier: ReceiverTableViewCell.identifier)
        tableView.register(SenderTableViewCell.self, forCellReuseIdentifier: SenderTableViewCell.identifier)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userId = messages[indexPath.row].senderId
        if userId == "user1" {
            let cell = tableView.dequeueReusableCell(withIdentifier: SenderTableViewCell.identifier) as! SenderTableViewCell
            cell.setup()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReceiverTableViewCell.identifier) as! ReceiverTableViewCell
            cell.setup()
            return cell
        }
        
    }
}
