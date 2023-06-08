//
//  MorePageViewController.swift
//  Chirp
//
//  Created by Siarhei Anoshka on 8.06.23.
//

import UIKit

class MorePageViewController: UIViewController {

    var cellNames: [String] = ["Push Notification", "Contributors", "Logout"]
    
    let userProfileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "mountains")
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Cameron Elizabeth Williamson"
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    let userPhoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "+91 999 2222 433"
        label.font = UIFont.systemFont(ofSize: 18, weight: .thin)
        return label
    }()
    
    let moreTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "More"
        doBasicSettings()
    }

    private func doBasicSettings() {
        view.backgroundColor = .white
        addSubviews()
        setupTableView()
        setupConstraints()
        setupUserImage()
    }
    
    private func addSubviews() {
        view.addSubview(userProfileImage)
        view.addSubview(userNameLabel)
        view.addSubview(userPhoneLabel)
        view.addSubview(moreTableView)
    }
    
    private func setupTableView() {
        moreTableView.delegate = self
        moreTableView.dataSource = self
        moreTableView.register(MorePageTableViewCell.self, forCellReuseIdentifier: MorePageTableViewCell.identifier)
        moreTableView.rowHeight = 80
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            userProfileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 125),
            userProfileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            userProfileImage.widthAnchor.constraint(equalToConstant: 110),
            userProfileImage.heightAnchor.constraint(equalToConstant: 110),
            
            userNameLabel.topAnchor.constraint(equalTo: userProfileImage.topAnchor, constant: 15),
            userNameLabel.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 20),
            userNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            userPhoneLabel.bottomAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 30),
            userPhoneLabel.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 20),
            userPhoneLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            moreTableView.topAnchor.constraint(equalTo: userProfileImage.bottomAnchor, constant: 25),
            moreTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            moreTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            moreTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    private func setupUserImage() {
        userProfileImage.layoutIfNeeded()
        userProfileImage.layer.masksToBounds = true
        userProfileImage.contentMode = .scaleAspectFill
        userProfileImage.layer.cornerRadius = userProfileImage.layer.frame.size.height/2
    }
}

extension MorePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moreTableView.dequeueReusableCell(withIdentifier: MorePageTableViewCell.identifier, for: indexPath) as! MorePageTableViewCell
        
        let name = cellNames[indexPath.row]
        cell.titleLabel.text = name
        cell.cellImage.image = UIImage(named: name)
        return cell
    }
}
