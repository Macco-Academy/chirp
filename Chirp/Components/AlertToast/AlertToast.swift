//
//  AlertToast.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 07.06.23.
//

import UIKit
import SwiftMessages

public final class AlertToast {
    
    public static func showAlert(message: String, type: AlertType) {
        let view = MessageView.viewFromNib(layout: .cardView)
        view.configureTheme(backgroundColor: type.backgroundColor, foregroundColor: type.tintColor, iconImage: type.icon)
        view.configureContent(title: "", body: message)
        view.button?.isHidden = true

        var config = SwiftMessages.defaultConfig
        config.duration = .seconds(seconds: 3)
        config.presentationStyle = .top
        config.dimMode = .none
        config.interactiveHide = true
        SwiftMessages.show(config: config, view: view)
    }
}
