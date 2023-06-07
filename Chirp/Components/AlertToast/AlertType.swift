//
//  AlertType.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 07.06.23.
//

import UIKit

public enum AlertType {
    case success, error, info
    
    var backgroundColor: UIColor {
        switch self {
        case .success:
            return .successGreen
        case .error:
            return .errorRed
        case .info:
            return .grey
        }
    }
    
    var tintColor: UIColor {
        switch self {
        case .success, .error, .info:
            return .white
        }
    }
    
    var icon: UIImage {
        switch self {
        case .success:
            return .checkmarkCircleFill
        case .error:
            return .xmarkOctagonFill
        case .info:
            return .infoCircleFill
        }
    }
}
