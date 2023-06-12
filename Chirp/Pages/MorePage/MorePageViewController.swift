//
//  MorePageViewController.swift
//  Chirp
//
//  Created by Siarhei Anoshka on 8.06.23.
//

import UIKit
import Combine

class MorePageViewController: UIViewController {

    enum CellNames: String, CaseIterable {
        case pushNotification = "Push Notification"
        case contributors = "Contributors"
        case logout = "Logout"
        case delete = "Delete Account"
    }
    
    let rows: [CellNames] = [.pushNotification, .contributors, .logout, .delete]
    
    private let morepageViewModel = MorePageViewModel()
    private var cancellables: Set<AnyCancellable> = []
        
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
        setupListner()
    }
    
    private func setupListner() {
        morepageViewModel.logoutSuccessful.sink { success in
            if success {
                LoginPageViewController().makeRootViewController()
            }
        }.store(in: &cancellables)
        
        morepageViewModel.deleteSuccessful.sink { success in
            if success {
                LoginPageViewController().makeRootViewController()
            }
        }.store(in: &cancellables)
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
         view.populate(with: UserDefaults.standard.currentUser)
         return view
    }
}

extension MorePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moreTableView.dequeueReusableCell(withIdentifier: MorePageTableViewCell.identifier, for: indexPath) as! MorePageTableViewCell
        let name = rows[indexPath.row].rawValue
        cell.titleLabel.text = name
        cell.cellImage.image = UIImage(named: name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch rows[indexPath.row] {
        case .pushNotification:
            return
        case .contributors:
            let contactsVC = ContactsViewController()
            contactsVC.type = .contributors
            contactsVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(contactsVC, animated: true)
        case .logout:
            AlertToast.showAlertWithButton(title: "Logout?",
                                           message: "Are you sure you would like to log out? \nYour chat history will be cleared and you'll need to login again",
                                           type: .info,
                                           buttonTitle: "Logout") {
                self.morepageViewModel.logoutUser()
            }
        case .delete:
            AlertToast.showAlertWithButton(title: "Delete Account?", message: "Are you sure you would like to delete your account? \nBy deleting your account permanently you will: \nDelete all messages and message history. ", type: .info, buttonTitle: "Delete Account") {
                let uid: String = UserDefaults.standard.currentUser?.id ?? "Cant find user"
                let loginVC = LoginPageViewController()
                loginVC.modalPresentationStyle = .fullScreen
                
                self.morepageViewModel.deleteUser(userID: uid)
                self.present(loginVC, animated: true)
            }
        default:
            return
        }
    }
}
