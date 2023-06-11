//
//  RegistrationViewController.swift
//  Chirp
//
//  Created by Siarhei Anoshka on 7.06.23.
//

import UIKit
import Photos
import Combine
import MobileCoreServices

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    private let viewModel: RegistrationViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    let createAccLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create Account"
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()

    let userAvatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage.placeholderImage
        return imageView
    }()

    let addImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .appBrown
        view.layer.cornerRadius = 15
        let addImage = UIImageView()
        addImage.translatesAutoresizingMaskIntoConstraints = false
        addImage.image = UIImage.addImage
        addImage.tintColor = .systemBackground
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
    

    // Life cycle
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        doBasicSettings()
        setupListeners()
    }

    // Setup
    private func doBasicSettings(){
        addSubviews()
        setupConstraints()
        setupUserImage()
        tuneAddBtn()
        setupTextField()
        setupSubmitButton()
    }

    private func addSubviews(){
        view.addSubview(createAccLabel)
        view.addSubview(userAvatarImageView)
        view.addSubview(addImageView)
        view.addSubview(userNameTextField)
        view.addSubview(submitButton)
    }

    private func setupConstraints(){
        NSLayoutConstraint.activate([
            createAccLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            createAccLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            createAccLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),

            userAvatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userAvatarImageView.topAnchor.constraint(equalTo: createAccLabel.bottomAnchor, constant: 65),
            userAvatarImageView.widthAnchor.constraint(equalToConstant: 130),
            userAvatarImageView.heightAnchor.constraint(equalToConstant: 130),

            addImageView.topAnchor.constraint(equalTo: userAvatarImageView.topAnchor),
            addImageView.leadingAnchor.constraint(equalTo: userAvatarImageView.leadingAnchor, constant: 93),
            addImageView.widthAnchor.constraint(equalToConstant: 30),
            addImageView.heightAnchor.constraint(equalToConstant: 30),

            userNameTextField.topAnchor.constraint(equalTo: userAvatarImageView.bottomAnchor, constant: 30),
            userNameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            userNameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25),
            userNameTextField.heightAnchor.constraint(equalToConstant: 40),

            submitButton.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 30),
            submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25),
            submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25)
        ])
    }

    private func setupUserImage(){
        userAvatarImageView.layoutIfNeeded()
        userAvatarImageView.contentMode = .scaleAspectFill
        userAvatarImageView.layer.masksToBounds = true
        userAvatarImageView.layer.cornerRadius = userAvatarImageView.layer.frame.size.width/2
    }

    private func tuneAddBtn() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addImageBtn))
        addImageView.addGestureRecognizer(tapGesture)
        addImageView.isUserInteractionEnabled = true
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

    @objc private func addImageBtn() {
        checkGalleryPermission()
    }
    
    // Gallery
    private func checkGalleryPermission() {
        let galleryAuthStatus = PHPhotoLibrary.authorizationStatus()
        switch galleryAuthStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ [weak self] status in
                if status == PHAuthorizationStatus.authorized {
                    DispatchQueue.main.async { self?.openGallery() }
                }
            })
        case .authorized:
            self.openGallery()
        case .denied, .restricted:
            AlertToast.showAlert(message: "Library access is required to set your profile picture.", type: .error)
        default:
            break
        }
    }
    
    private func openGallery() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.mediaTypes = [kUTTypeImage as String]
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    // Registration
    private func setupSubmitButton(){
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    }
    
    @objc private func submitButtonTapped(){
        guard let name = userNameTextField.text, !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            AlertToast.showAlert(message: "Please, enter your name", type: .error)
            return
        }
        
        let profileImage = userAvatarImageView.image == UIImage.placeholderImage ? nil : userAvatarImageView.image
        viewModel.createAccount(name: name, profileImage: profileImage)
    }
    
    // Listeners
    private func setupListeners() {
        viewModel.didRegisterUser.sink { [weak self] success in
            guard success else { return }
            
            self?.navigateToHome()
        }
        .store(in: &cancellables)
    }
    
    // Navigation
    private func navigateToHome() {
        let controller = HomeTabBarController()
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
}

// MARK: - UIImagePickerController Delegate
extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        guard mediaType == kUTTypeImage else { return }
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            userAvatarImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
