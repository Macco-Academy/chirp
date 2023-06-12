//
//  HomeTabBarController.swift
//  Chirp
//
//  Created by Kwaku Dapaah on 6/7/23.
//

import UIKit

class HomeTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let vc1 = ChatsViewController()
        let vc2 = ContactsViewController()
        vc2.title = vc2.type.pageName
        let vc3 = MorePageViewController()
        vc3.title = "More"
        
        self.setViewControllers([UINavigationController(rootViewController: vc1),
                                 UINavigationController(rootViewController: vc2),
                                 UINavigationController(rootViewController: vc3)], animated: true)
        self.tabBar.tintColor = .appBrown
        self.tabBar.unselectedItemTintColor = .appBrownSecondary
        
        guard let items = self.tabBar.items else {
            return
        }
        
        let activeImages = [UIImage.ellipsisMessageFill, UIImage.personFill, UIImage.settingsFill]
        let inactiveImages = [UIImage.ellipsisMessageBordered, UIImage.personBordered, UIImage.settingsBordered]
        
        for i in 0..<items.count {
            items[i].image = inactiveImages[i]
            items[i].selectedImage = activeImages[i]
        }
        
        let request = UpdateFCMTokenRequest(userId: UserDefaults.standard.currentUser?.id ?? "",
                                            token: UserDefaults.standard.fcmToken ?? "")
        NetworkService.shared.updateFCMToken(request: request)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}
