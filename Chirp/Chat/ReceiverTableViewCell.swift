//
//  ReceiverTableViewCell.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 07.06.23.
//

import UIKit

class ReceiverTableViewCell: UITableViewCell {
    static let identifier = "ReceiverTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Hello 2"
        label.textColor = .white
        label.numberOfLines = 0
        label.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return label
    }()
    
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
        stackView.addArrangedSubview(label)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -150),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
