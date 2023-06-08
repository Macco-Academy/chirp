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

    let addImage: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appBrown
        view.layer.cornerRadius = 15
        let addImage = UIImageView()
        addImage.translatesAutoresizingMaskIntoConstraints = false
        addImage.image = UIImage.addImage
        addImage.tintColor = .white
        view.addSubview(addImage)
        
        let imagePadding: CGFloat = 3
        NSLayoutConstraint.activate([
            addImage.topAnchor.constraint(equalTo: view.topAnchor, constant: imagePadding),
            addImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: imagePadding),
            addImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -imagePadding),
            addImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -imagePadding),
        ])
        return view
    }()

    let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Full Name"
        return textField
    }()

    let submitButton: Button = {
        let button = Button()
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var user = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        doBasicSettings()
    }

    private func doBasicSettings(){
        addSubviews()
        setupConstraints()
        setupUserImage()
        tuneAddBtn()
        setupTextField()
        checkButton()
    }

    private func addSubviews(){
        view.addSubview(createAccLabel)
        view.addSubview(userAvatarImage)
        view.addSubview(addImage)
        view.addSubview(userNameTextField)
        view.addSubview(submitButton)
    }

    private func setupConstraints(){
        NSLayoutConstraint.activate([
            createAccLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
            userNameTextField.heightAnchor.constraint(equalToConstant: 40),

            submitButton.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 30),
            submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25)
        ])
    }
    
    private func checkButton(){
        submitButton.addTarget(self, action: #selector(validateForm), for: .touchUpInside)
    }
    
    @objc private func validateForm(){
        if let text = userNameTextField.text {
            if text.trimmingCharacters(in: .whitespaces).isEmpty {
                AlertToast.showAlert(message: "Please, enter your name", type: .error)
            } else {
                navigationController?.setViewControllers([HomeTabBarController()], animated: true)
            }
        }
    }

    private func setupUserImage(){
        userAvatarImage.layoutIfNeeded()
        userAvatarImage.contentMode = .scaleAspectFill
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
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    @objc private func addImageBtn(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            userAvatarImage.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
