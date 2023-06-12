//
//  UIView+Extension.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 11.06.23.
//

import UIKit

extension UIView {
    func addRoundedCorners(corners: UIRectCorner, radius: CGFloat) {
        layer.cornerRadius = radius
        var maskedCorners: CACornerMask = []
        if corners.contains(.bottomLeft) {
            maskedCorners.insert(.layerMinXMaxYCorner)
        }
        if corners.contains(.bottomRight) {
            maskedCorners.insert(.layerMaxXMaxYCorner)
        }
        if corners.contains(.topLeft) {
            maskedCorners.insert(.layerMinXMinYCorner)
        }
        if corners.contains(.topRight) {
            maskedCorners.insert(.layerMaxXMinYCorner)
        }
        layer.maskedCorners = maskedCorners
        
    }
}
