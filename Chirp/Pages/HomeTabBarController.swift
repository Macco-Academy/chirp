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
  
        
        let vc1 = FirstViewVC()
        let vc2 = ContactsViewController()
        let vc3 = ThirdViewVC()
        
        let navCon = UINavigationController(rootViewController: vc2)
        
        self.setViewControllers([vc1, navCon, vc3], animated: true)
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
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    


}


class FirstViewVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
    }
}

class ThirdViewVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
    }
}

