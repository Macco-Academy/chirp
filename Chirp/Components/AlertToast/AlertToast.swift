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
    
    public static func showAlertWithButton(title: String, message: String, type: AlertType, buttonTitle: String, buttonAction: (() -> Void)?) {
        let view = MessageView.viewFromNib(layout: .centeredView)
        view.configureTheme(backgroundColor: type.tintColor, foregroundColor: .black, iconImage: type.icon)
        view.configureContent(title: title, body: message)
        view.button?.isHidden = false
        view.button?.setTitle(buttonTitle, for: .normal)
        view.button?.backgroundColor = .appBrown
        view.buttonTapHandler = { _ in
            buttonAction?()
            SwiftMessages.hide()
        }

        var config = SwiftMessages.defaultConfig
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .blur(style: .systemUltraThinMaterialDark, alpha: 0.9, interactive: true)
        config.interactiveHide = false
        SwiftMessages.show(config: config, view: view)
    }
}
