//
//  ContactsTableViewCell.swift
//  Chirp
//
//  Created by Uzoh Okwara on 07/06/2023.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    static let id = "\(ContactsTableViewCell.self)"
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with data: ContactsDetails) {
        image.image = data.image
        typesLabel.text = data.text
    }
    
    
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.infoCircleFill
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let typesLabel: UILabel = {
        let label = UILabel()
        label.text = "Test"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var hStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(typesLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    lazy var cellView: UIView = {
        let view = UIView()
        view.addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            hStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            hStack.bottomAnchor.constraint(equalTo:view.bottomAnchor, constant: -10)
        ])
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setupView() {
        selectionStyle = .none
        addSubview(cellView)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor),
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
