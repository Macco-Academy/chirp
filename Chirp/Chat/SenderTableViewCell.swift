//
//  SenderTableViewCell.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 07.06.23.
//

import UIKit

class SenderTableViewCell: UITableViewCell {
    static let identifier = "SenderTableViewCell"
    
    func setup() {
        backgroundColor = .appBrownSecondary
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

}
