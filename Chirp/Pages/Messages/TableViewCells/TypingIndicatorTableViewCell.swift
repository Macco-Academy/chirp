//
//  TypingIndicatorTableViewCell.swift
//  Chirp
//
//  Created by Stepan Kukharskyi on 6/15/23.
//

import UIKit

class TypingIndicatorTableViewCell: UITableViewCell {
    
    static let identifier = "TypingIndicatorTableViewCell"
    
    let numberOfDots = 3
    let dotSize: CGFloat = 10
    let dotSpacing: CGFloat = 5
    let dotColor: UIColor = .systemGray2
    let dotHighlightColor: UIColor = .systemGray
    
    private let padding: CGFloat = 10
    
    private var bubbleHeight: CGFloat {
        return (2*padding) + dotSize
    }
    
    private var bubbleWidth: CGFloat {
        return (2*padding) + (dotSize*CGFloat(numberOfDots)) + (dotSpacing*CGFloat(numberOfDots-1))
    }
    
    private let bubbleBackgroundView = UIView()
    private let stackView = UIStackView()
    private var dotAnimationTimer: Timer?
    
    
    // Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopDotAnimation()
    }
    
    
    // Animation
    func startDotAnimation() {
        stopDotAnimation()
        
        var dotIndex = 0
        let timerDuration: TimeInterval = 0.45
        let animationDuration: TimeInterval = 0.4
        
        dotAnimationTimer = Timer.scheduledTimer(withTimeInterval: timerDuration, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            UIView.animate(withDuration: animationDuration) {
                self.stackView.arrangedSubviews[dotIndex].backgroundColor = self.dotColor
            } completion: { _ in
                UIView.animate(withDuration: animationDuration) {
                    self.stackView.arrangedSubviews[dotIndex].backgroundColor = self.dotHighlightColor
                }
            }
            
            dotIndex += 1
            if dotIndex >= self.stackView.arrangedSubviews.count {
                dotIndex = 0
            }
        }
    }
    
    func stopDotAnimation() {
        dotAnimationTimer?.invalidate()
        dotAnimationTimer = nil
        stackView.arrangedSubviews.forEach { $0.backgroundColor = dotColor }
    }
    
    // Setup
    private func setup() {
        selectionStyle = .none
        setupBubble()
        setupStack()
        setupDots()
        setupConstraints()
        startDotAnimation()
    }
    
    private func setupBubble() {
        bubbleBackgroundView.backgroundColor = .appBrownSecondary
        bubbleBackgroundView.addRoundedCorners(corners: [.topLeft, .topRight, .bottomRight], radius: bubbleHeight / 2)
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupStack() {
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        addSubview(bubbleBackgroundView)
        bubbleBackgroundView.addSubview(stackView)
        NSLayoutConstraint.activate([
            bubbleBackgroundView.widthAnchor.constraint(equalToConstant: bubbleWidth),
            bubbleBackgroundView.heightAnchor.constraint(equalToConstant: bubbleHeight),
            bubbleBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            bubbleBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            
            stackView.centerXAnchor.constraint(equalTo: bubbleBackgroundView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: bubbleBackgroundView.centerYAnchor)
        ])
    }
    
    private func setupDots() {
        for _ in 0..<numberOfDots {
            let dot = createDot()
            stackView.addArrangedSubview(dot)
        }
    }
    
    private func createDot() -> UIView {
        let dot = UIView()
        dot.backgroundColor = dotColor
        dot.layer.cornerRadius = dotSize/2
        dot.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dot.widthAnchor.constraint(equalToConstant: dotSize),
            dot.heightAnchor.constraint(equalToConstant: dotSize)
        ])
        
        return dot
    }
}
