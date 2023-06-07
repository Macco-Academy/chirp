//
//  SenderTableViewCell.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 07.06.23.
//

import UIKit

class SenderTableViewCell: UITableViewCell {
    static let identifier = "SenderTableViewCell"
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .appBrownSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setup() {
        setupViews()
        setupConstraints()
    }

    private func setupViews() {
        addSubview(stackView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -150),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
