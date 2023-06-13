//
//  HapticFeedback.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 13.06.23.
//

import UIKit

struct HapticFeedback {
    enum Style {
        case error, success, warning, light, heavy, selection
    }
    
    static func play(type: Style) {
        switch type {
        case .error:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        case .success:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        case .warning:
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
        case .light:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .heavy:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        case .selection:
            let generator = UISelectionFeedbackGenerator()
            generator.selectionChanged()
        }
    }
}
