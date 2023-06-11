//
//  MorePageViewController.swift
//  Chirp
//
//  Created by Siarhei Anoshka on 8.06.23.
//

import UIKit

class MorePageViewController: UIViewController {

    enum CellNames: String, CaseIterable {
        case pushNotification = "Push Notification"
        case contributors = "Contributors"
        case logout = "Logout"
    }
        
    let moreTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "More"
        navigationController?.navigationBar.prefersLargeTitles = true
        doBasicSettings()
    }

    private func doBasicSettings() {
        view.backgroundColor = .systemBackground
        view.addSubview(moreTableView)
        setupTableView()
        setupConstraints()
    }
    
    private func setupTableView() {
        moreTableView.delegate = self
        moreTableView.dataSource = self
        moreTableView.register(MorePageTableViewCell.self, forCellReuseIdentifier: MorePageTableViewCell.identifier)
        moreTableView.register(CustomHeader.self, forHeaderFooterViewReuseIdentifier: CustomHeader.identifier)
        moreTableView.rowHeight = 80
        moreTableView.sectionHeaderHeight = 150
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            moreTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            moreTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            moreTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            moreTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = moreTableView.dequeueReusableHeaderFooterView(withIdentifier: CustomHeader.identifier) as! CustomHeader
         view.profilePicture.image = UIImage(named: "mountains")
         view.userNameLabel.text = "Cameron Elizabeth Williamson"
         view.userPhoneNumber.text = "+91 999 2222 433"
         return view
    }
}

extension MorePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellNames.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moreTableView.dequeueReusableCell(withIdentifier: MorePageTableViewCell.identifier, for: indexPath) as! MorePageTableViewCell
        let arrayOfNames: [CellNames] = [.pushNotification, .contributors, .logout]
        let name = arrayOfNames[indexPath.row].rawValue
        cell.titleLabel.text = name
        cell.cellImage.image = UIImage(named: name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rows: [CellNames] = [.pushNotification, .contributors, .logout]
        if rows[indexPath.row] == .contributors {
            let contactsVC = ContactsViewController()
            contactsVC.type = .contributors
            navigationController?.pushViewController(contactsVC, animated: true)
        }
    }
}
