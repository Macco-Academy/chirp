//
//  MorePageTableViewCell.swift
//  Chirp
//
//  Created by Siarhei Anoshka on 8.06.23.
//

import UIKit

class MorePageTableViewCell: UITableViewCell {
    
    static let identifier = "MorePageTableViewCell"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let cellImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        doBasicSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func doBasicSettings(){
        addSubviews()
        setupConstraints()
        setupcImages()
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(cellImage)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 65),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            
            cellImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            cellImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellImage.widthAnchor.constraint(equalToConstant: 50),
            cellImage.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupcImages() {
        cellImage.layoutIfNeeded()
        cellImage.layer.masksToBounds = true
    }
}
