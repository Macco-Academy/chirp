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
        let vc2 = SecondViewVC()
        let vc3 = ThirdViewVC()
        self.setViewControllers([vc1, vc2, vc3], animated: true)
        self.tabBar.tintColor = .appBrown
        self.tabBar.unselectedItemTintColor = .appBrownSecondary
        
        guard let items = self.tabBar.items else {
            return
        }
        
        let tabIconImages = [UIImage.ellipsisMessageFill, UIImage.personFill, UIImage.settingsFill]
        
        for i in 0..<items.count {
            items[i].image = tabIconImages[i]
        }
        
    }
    
    


}


class FirstViewVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .cyan
    }
}


class SecondViewVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
}


class ThirdViewVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .brown
    }
}

