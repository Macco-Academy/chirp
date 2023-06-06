//
//  Button.swift
//  Chirp
//
//  Created by Uzoh Okwara on 06.06.23.
//

import UIKit
import Lottie

@IBDesignable class Button: UIButton {
    
    let buttonPadding: CGFloat = 10
    
    private let loadingView = LottieAnimationView(name: AnimationName.buttonLoaderWhite)
    
    @IBInspectable var isLoading: Bool = false {
        didSet {
            loadingView.stop()
            if isLoading {
                loadingView.play()
            }
            loadingView.isHidden = !isLoading
            setTitleColor(isLoading ? .clear : .white, for: .normal)
        }
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(loadingView)
        backgroundColor = UIColor.appBrown
        clipsToBounds = true
        layer.cornerRadius = 6
        
        contentEdgeInsets = .init(top: buttonPadding, left: buttonPadding, bottom: buttonPadding, right: buttonPadding)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.isUserInteractionEnabled = false
        loadingView.loopMode = .loop
        loadingView.isHidden = true
        setTitleColor(.white, for: .normal)
        setTitleColor(UIColor.appBrownSecondary, for: .highlighted)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
