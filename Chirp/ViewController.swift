//
//  ViewController.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 04.06.23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let vc = RegistrationViewController()
        present(vc, animated: true)
    }
}
