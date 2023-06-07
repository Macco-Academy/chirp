//
//  LoginPageViewController.swift
//  Chirp
//
///  Created by ioannis on 7/6/23.
//

import UIKit
import PhoneNumberKit

class LoginPageViewController: UIViewController {
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "What’s your phone number?"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 32,weight:.bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    
    private let subTitleLabel:UILabel = {
        let label = UILabel()
        label.text = "We’ll send you a code to verify your number"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14,weight:.light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        return label
    }()
    private let numberTextField : PhoneNumberTextField = {
        let textField = PhoneNumberTextField()
        let phoneNumberKit = PhoneNumberKit()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .namePhonePad
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.withFlag = true
        textField.placeholder = "Enter your mobile number"
        textField.withExamplePlaceholder = true
        textField.textContentType = .telephoneNumber
        
        return textField
    }()
    
    private let proceedButton: Button = {
        let button = Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Proceed", for: .normal)
        button.addTarget(self, action:  #selector(loginPressed), for: .touchUpInside)
        return button
    }()
    
    
    let constraintNumber:CGFloat = 24
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        
    }
    
    
    private func layout(){
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(numberTextField)
        view.addSubview(proceedButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constraintNumber),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: constraintNumber),
            subTitleLabel.topAnchor.constraint(equalTo:titleLabel.bottomAnchor, constant: 4),
            subTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constraintNumber),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: constraintNumber),
            numberTextField.topAnchor.constraint(equalTo:subTitleLabel.bottomAnchor, constant: 10),
            numberTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:  constraintNumber),
            numberTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -constraintNumber),
            proceedButton.topAnchor.constraint(equalTo:numberTextField.bottomAnchor, constant: 50),
            proceedButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: constraintNumber),
            proceedButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -constraintNumber),
            proceedButton.heightAnchor.constraint(equalToConstant: 40)
            
            
        ])
        
    }
}

extension LoginPageViewController {
    //actions
    @objc private func loginPressed() {
        print("login pressed")
    }
}
