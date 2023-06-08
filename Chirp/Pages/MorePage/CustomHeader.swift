//
//  CustomHeader.swift
//  Chirp
//
//  Created by Siarhei Anoshka on 8.06.23.
//

import UIKit

class CustomHeader: UITableViewHeaderFooterView {
    
    static let identifier: String = "CustomHeader"
    
    let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    let userPhoneNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .thin)
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        basicSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func basicSetup(){
        contentView.backgroundColor = .white
        setupSubviews()
        setupConstraints()
        setupProfilePicture()
    }
    
    private func setupSubviews() {
        contentView.addSubview(profilePicture)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userPhoneNumber)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            profilePicture.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profilePicture.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profilePicture.heightAnchor.constraint(equalToConstant: 110),
            profilePicture.widthAnchor.constraint(equalToConstant: 110),
            
            userNameLabel.topAnchor.constraint(equalTo: profilePicture.topAnchor, constant: 15),
            userNameLabel.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 20),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            userPhoneNumber.bottomAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: -15),
            userPhoneNumber.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 20),
            userPhoneNumber.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func setupProfilePicture(){
        profilePicture.layoutIfNeeded()
        profilePicture.layer.masksToBounds = true
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.layer.cornerRadius = profilePicture.layer.frame.size.height/2
    }
}
