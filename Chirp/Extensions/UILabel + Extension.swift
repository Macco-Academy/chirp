//
//  UILabel + Extension.swift
//  Chirp
//
//  Created by Uzoh Okwara on 07/06/2023.
//

import UIKit

extension UILabel {
    static func create(text: String? = nil, textColor: UIColor? = nil, font: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular), textAlignment: NSTextAlignment = .left, numberOfLines: Int = 0, clabel: ((UILabel) -> (Void))? = nil) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.numberOfLines = numberOfLines
        clabel?(label)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    func addSubviews(_ views: [UIView]) {
        for view in views {
            addSubview(view)
        }
    }
}
