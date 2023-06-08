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
        let vc1 = UINavigationController(rootViewController: ChatsViewController())
        let vc2 = UINavigationController(rootViewController: ContactsViewController())
        let vc3 = UINavigationController(rootViewController: MorePageViewController())
        
        self.setViewControllers([vc1, vc2, vc3], animated: true)
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }   
}
