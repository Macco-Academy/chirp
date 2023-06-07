//
//  ReceiverTableViewCell.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 07.06.23.
//

import UIKit

class ReceiverTableViewCell: UITableViewCell {
    static let identifier = "ReceiverTableViewCell"
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .appBrown
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
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -150),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}