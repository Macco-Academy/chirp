//
//  Loader.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 10.06.23.
//

import UIKit
import Lottie

final class LoaderView {
    static let shared = LoaderView()
    
    private lazy var animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "loader_animation")
        view.loopMode = .loop
        view.play()
        
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 100)
        ])
        return view
    }()
    
    private lazy var titleLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private lazy var messageLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 300)
        ])
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addArrangedSubview(animationView)
        view.addArrangedSubview(titleLbl)
        view.addArrangedSubview(messageLbl)
        return view
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        return view
    }()
    
    func show(title: String? = nil, message: String? = nil, completion: (() -> Void)? = nil) {
        backgroundView.alpha = 0
        UIApplication.shared.keyWindow?.addSubview(backgroundView)
        if let parentView = backgroundView.superview {
            NSLayoutConstraint.activate([
                backgroundView.topAnchor.constraint(equalTo: parentView.topAnchor),
                backgroundView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                backgroundView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
                backgroundView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            ])
        }
        titleLbl.text = title
        messageLbl.text = message
        titleLbl.isHidden = title == nil
        messageLbl.isHidden = message == nil
        animationView.play()
        UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
            self?.backgroundView.alpha = 1
        } completion: { _ in
            completion?()
        }
    }
    
    func hide(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.15, delay: 0) { [weak self] in
            self?.backgroundView.alpha = 0
        } completion: { [weak self] _ in
            self?.animationView.stop()
            self?.backgroundView.removeFromSuperview()
            completion?()
        }
    }
}
