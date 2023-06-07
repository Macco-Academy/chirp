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
        
        guard let items = self.tabBar.items else {
            return
        }
        
        let tabIconImages = ["ellipsis.message.fill", "person.2.fill", "squareshape.split.2x2"]
        
        for i in 0..<items.count {
            items[i].image = UIImage(systemName: tabIconImages[i])
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

