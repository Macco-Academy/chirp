//
//  OTPViewController.swift
//  Chirp
//
//  Created by Stepan Kukharskyi on 6/5/23.
//

import UIKit

class OTPViewController: UIViewController {
    
    var code: String?
    var phoneNumber: String?
    var countdownDuration: Double = 30
    
    private let xPadding: CGFloat = 25

    private let closeButton = UIButton()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let phoneNumberLabel = UILabel()
    private let passcodeView = PasscodeView()
    private let sendAgainPlaceholder = UIView()
    private let countdownView = CountdownView()
    
    var isCountdownActive = true {
        didSet { updateUI() }
    }
    
    // Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        layoutUI()
        setupUIElements()
        handlePasscode()
        isCountdownActive = true
    }
    
    // UI
    private func layoutUI() {
        [closeButton, titleLabel, subtitleLabel,
         phoneNumberLabel, passcodeView, sendAgainPlaceholder, countdownView].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 45),
            closeButton.heightAnchor.constraint(equalToConstant: 45),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xPadding),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xPadding),
            
            phoneNumberLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 5),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xPadding),
            
            passcodeView.heightAnchor.constraint(equalToConstant: 45),
            passcodeView.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: 24),
            passcodeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xPadding),
            passcodeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -xPadding),

            sendAgainPlaceholder.heightAnchor.constraint(equalToConstant: 45),
            sendAgainPlaceholder.topAnchor.constraint(equalTo: passcodeView.bottomAnchor, constant: 24),
            sendAgainPlaceholder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: xPadding),
            sendAgainPlaceholder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -xPadding),

            countdownView.widthAnchor.constraint(equalToConstant: 125),
            countdownView.heightAnchor.constraint(equalToConstant: 125),
            countdownView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownView.topAnchor.constraint(equalTo: passcodeView.bottomAnchor, constant: 50)
        ])
    }
    
    private func setupUIElements() {
        setupCloseButton()
        setupLabels()
        setupSendAgainPlaceholder()
        self.view.backgroundColor = .systemBackground
    }
    
    // Close button
    private func setupCloseButton() {
        closeButton.tintColor = .label
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }
    
    // Labels
    private func setupLabels() {
        titleLabel.text = "What's the code?"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        
        subtitleLabel.text = "Enter the code we've sent to"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        phoneNumberLabel.text = phoneNumber ?? "+X XXX XXX XXXX"
        phoneNumberLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
    }
    
    // Passcode
    private func handlePasscode() {
        passcodeView.didFinishEnteringCode = { [weak self] code in
            //TODO: Validate code
            // success
            self?.dismiss(animated: true)
            
            // invalid
            // TODO: Show error
        }
    }
    
    // Send again section
    private func setupSendAgainPlaceholder() {
        let questionLabel = UILabel()
        questionLabel.text = "Didn't receive code?"
        questionLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        sendAgainPlaceholder.addSubview(questionLabel)

        let sendAgainLabel = UILabel()
        sendAgainLabel.text = "Send again"
        sendAgainLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        sendAgainLabel.translatesAutoresizingMaskIntoConstraints = false
        sendAgainPlaceholder.addSubview(sendAgainLabel)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSendAgain))
        sendAgainLabel.isUserInteractionEnabled = true
        sendAgainLabel.addGestureRecognizer(tapGesture)

        NSLayoutConstraint.activate([
            questionLabel.leadingAnchor.constraint(equalTo: sendAgainPlaceholder.leadingAnchor),
            questionLabel.centerYAnchor.constraint(equalTo: sendAgainPlaceholder.centerYAnchor),
            
            sendAgainLabel.topAnchor.constraint(equalTo: sendAgainPlaceholder.topAnchor),
            sendAgainLabel.bottomAnchor.constraint(equalTo: sendAgainPlaceholder.bottomAnchor),
            sendAgainLabel.leadingAnchor.constraint(equalTo: questionLabel.trailingAnchor, constant: 5)
        ])
    }
    
    @objc private func didTapSendAgain() {
        //TODO: Resend code
        isCountdownActive = true
    }

    // Updates
    private func updateUI() {
        countdownView.isHidden = !isCountdownActive
        sendAgainPlaceholder.isHidden = isCountdownActive
        
        if isCountdownActive { showCountdown() }
    }
    
    private func showCountdown() {
        countdownView.startCountdown(duration: countdownDuration)
        
        countdownView.didFinishCountdown = { [weak self] in
            self?.isCountdownActive = false
        }
    }
}
