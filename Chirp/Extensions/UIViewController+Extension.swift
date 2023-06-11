//
//  UIViewController+Extension.swift
//  Chirp
//
//  Created by Ady on 6/11/23.
//

import UIKit

extension UIViewController {
    func makeRootViewController() {
        let rootVC = UINavigationController(rootViewController: self)
        let window = (UIApplication.shared.keyWindow?.windowScene?.delegate as? SceneDelegate)?.window
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
}
