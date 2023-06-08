//
//  MorePageViewController.swift
//  Chirp
//
//  Created by Siarhei Anoshka on 8.06.23.
//

import UIKit

class MorePageViewController: UIViewController {

    let cellNames: [String] = ["Push Notification", "Contributors", "Logout"]
        
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
            moreTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            moreTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            moreTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            moreTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
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
