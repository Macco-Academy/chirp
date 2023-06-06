//
//  Button.swift
//  Chirp
//
//  Created by Uzoh Okwara on 06.06.23.
//

import UIKit
import Lottie

@IBDesignable class Button: UIButton {
    private let loadingView = LottieAnimationView(name: "button-loader-white")
    
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
        backgroundColor = UIColor(named: "app-brown")
        clipsToBounds = true
        layer.cornerRadius = 6
        
        contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.isUserInteractionEnabled = false
        loadingView.loopMode = .loop
        loadingView.isHidden = true
        setTitleColor(.white, for: .normal)
        setTitleColor(UIColor(named: "app-brown-secondary"), for: .highlighted)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
