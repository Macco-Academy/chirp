//
//  RegistrationViewController.swift
//  Chirp
//
//  Created by Siarhei Anoshka on 7.06.23.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    let createAccLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create Account"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    let userAvatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.placeholderImage
        return imageView
    }()
    
    let addImage: UIImageView = {
        let addImage = UIImageView()
        addImage.translatesAutoresizingMaskIntoConstraints = false
        addImage.image = UIImage.addImage
        return addImage
    }()
    
    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Full Name"
        return textField
    }()
    
    var user = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        doBasicSettings()
    }
    
    private func doBasicSettings(){
        addSubviews()
        setupConstraints()
        setupUserImage()
        tuneAddBtn()
        setupTextField()
        backgroundTapped()
    }
    
    private func addSubviews(){
        view.addSubview(createAccLabel)
        view.addSubview(userAvatarImage)
        view.addSubview(addImage)
        view.addSubview(userNameTextField)
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            createAccLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            createAccLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            createAccLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            
            userAvatarImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userAvatarImage.topAnchor.constraint(equalTo: createAccLabel.bottomAnchor, constant: 65),
            userAvatarImage.widthAnchor.constraint(equalToConstant: 130),
            userAvatarImage.heightAnchor.constraint(equalToConstant: 130),
            
            addImage.topAnchor.constraint(equalTo: userAvatarImage.topAnchor),
            addImage.leadingAnchor.constraint(equalTo: userAvatarImage.leadingAnchor, constant: 93),
            addImage.widthAnchor.constraint(equalToConstant: 30),
            addImage.heightAnchor.constraint(equalToConstant: 30),
            
            userNameTextField.topAnchor.constraint(equalTo: userAvatarImage.bottomAnchor, constant: 30),
            userNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            userNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupUserImage(){
        userAvatarImage.layoutIfNeeded()
        userAvatarImage.layer.masksToBounds = true
        userAvatarImage.layer.cornerRadius = userAvatarImage.layer.frame.size.width/2
    }
    
    private func tuneAddBtn() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addImageBtn))
        addImage.addGestureRecognizer(tapGesture)
        addImage.isUserInteractionEnabled = true
    }
    
    private func setupTextField() {
        userNameTextField.delegate = self
        userNameTextField.returnKeyType = .done
        userNameTextField.clearButtonMode = .always
        userNameTextField.autocorrectionType = .no
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        userNameTextField.leftView = paddingView
        userNameTextField.leftViewMode = .always
        userNameTextField.layer.borderWidth = 0.1
        userNameTextField.layer.cornerRadius = 8
        userNameTextField.font = UIFont.systemFont(ofSize: 20, weight: .light)
    }
    
    private func backgroundTapped(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func addImageBtn(){
        print("Here's some code to upload the image")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTextField.resignFirstResponder()
        guard let text = userNameTextField.text, !text.isEmpty else {
            return false
        }
        print("User Name is \(text)")
        user.name = text
        return true
    }
}

