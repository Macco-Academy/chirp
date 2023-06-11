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
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        contentView.backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
        setupProfilePicture()
    }
    
    private func setupSubviews() {
        contentView.addSubview(profilePicture)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(userNameLabel)
        stackView.addArrangedSubview(userPhoneNumber)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            profilePicture.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profilePicture.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profilePicture.heightAnchor.constraint(equalToConstant: 100),
            profilePicture.widthAnchor.constraint(equalToConstant: 100),
            
            stackView.centerYAnchor.constraint(equalTo: profilePicture.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: profilePicture.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func setupProfilePicture(){
        profilePicture.layoutIfNeeded()
        profilePicture.layer.masksToBounds = true
        profilePicture.contentMode = .scaleAspectFill
        profilePicture.layer.cornerRadius = profilePicture.layer.frame.size.height/2
    }
}
