//
//  PasscodeBoxView.swift
//  Chirp
//
//  Created by Stepan Kukharskyi on 6/5/23.
//

import UIKit

class PasscodeBoxView: UIView {
    
    private let valueLabel = UILabel()
    
    var value: String? {
        didSet { valueLabel.text = value ?? "" }
    }
    
    var activeColor: CGColor = #colorLiteral(red: 0.337254902, green: 0.1921568627, blue: 0.1450980392, alpha: 1)
    var inActiveColor: CGColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
    
    var isActive: Bool = false {
        didSet { self.layer.borderColor = isActive ? activeColor : inActiveColor }
    }
    
    
    // Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // UI
    private func setupUI() {
        self.backgroundColor = .clear
        self.addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            valueLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        setupValueLabel()
        setupBorder()
    }
    
    private func setupValueLabel() {
        valueLabel.textColor = .label
        valueLabel.textAlignment = .center
        valueLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    private func setupBorder() {
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        self.layer.borderColor = inActiveColor
    }
}
