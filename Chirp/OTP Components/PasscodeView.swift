//
//  PasscodeView.swift
//  Chirp
//
//  Created by Stepan Kukharskyi on 6/5/23.
//

import UIKit

class PasscodeView: UIView, UITextInputTraits {
    
    var maxLength = 6
    var keyboardType: UIKeyboardType = .numberPad
    
    private let stack = UIStackView()
    private var boxes = [PasscodeBoxView]()
    
    var code: String = "" {
        didSet {
            updateBoxes()
            triggerCodeCompletionIfNeeded()
        }
    }
    
    var didFinishEnteringCode: ((String) -> Void)?
    
    
    // Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        showKeyboard()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        showKeyboard()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBoxes()
    }
    
    // Keyboard
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func showKeyboard() {
        self.becomeFirstResponder()
    }
    
    // UI
    private func setupUI() {
        setupStack()
        self.addSubview(stack)
        self.backgroundColor = .clear
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func setupStack() {
        stack.spacing = 10
        stack.axis = .horizontal
        stack.distribution = .fillEqually

        boxes = (0..<maxLength).map{ _ in PasscodeBoxView() }
        boxes.forEach { stack.addArrangedSubview($0) }
    }
    
    // Passcode
    public func resetPasscode() {
        code = ""
        showKeyboard()
    }
    
    private func updateBoxes() {
        for (index, box) in boxes.enumerated() {
            box.value = getDigit(at: index)
            box.isActive = index == code.count
        }
    }
    
    private func getDigit(at index: Int) -> String {
        guard index >= 0, index < code.count else { return "" }
        
        let digitIndex = code.index(code.startIndex, offsetBy: index)
        return "\(code[digitIndex])"
    }
    
    private func triggerCodeCompletionIfNeeded() {
        guard code.count == maxLength else { return }
        
        self.resignFirstResponder()
        self.didFinishEnteringCode?(code)
    }
}

// MARK: - UIKeyInput
extension PasscodeView: UIKeyInput {
    var hasText: Bool {
        return code.count > 0
    }
    
    func insertText(_ text: String) {
        guard code.count < maxLength else { return }
        
        code.append(contentsOf: text)
    }
    
    func deleteBackward() {
        if hasText { code.removeLast() }
    }
}
