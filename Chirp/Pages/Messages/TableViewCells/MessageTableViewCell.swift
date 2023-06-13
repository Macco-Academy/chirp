//
//  MessageTableViewCell.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 11.06.23.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    static let identifier = "MessageTableViewCell"
    
    private let messageLbl: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        return label
    }()
    private let timestampLbl: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textAlignment = .right
        return label
    }()
    private let bubbleBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    private var viewModel: MessageCellViewModel!
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    
    private var showShareDialog: ((String?) -> Void)!
    
    func setup(viewModel: MessageCellViewModel, share: @escaping (String?) -> Void) {
        self.viewModel = viewModel
        self.showShareDialog = share
        setupViews()
        setupConstraints()
        populateViews()
        setupListeners()
    }
    
    private func setupViews() {
        addSubview(bubbleBackgroundView)
        bubbleBackgroundView.addSubview(stackView)
        stackView.addArrangedSubview(messageLbl)
        stackView.addArrangedSubview(timestampLbl)
        bubbleBackgroundView.addRoundedCorners(corners: viewModel.roundedCorners, radius: 20)
        
        bubbleBackgroundView.backgroundColor = viewModel.backgroundColor
        messageLbl.textColor = viewModel.textColor
        timestampLbl.textColor = viewModel.textColor
        selectionStyle = .none
    }
    
    private func setupListeners() {
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        addGestureRecognizer(longPressRecognizer)
    }
    
    @objc private func longPressed(sender: UITapGestureRecognizer) {
        if (sender.state == .began){
            HapticFeedback.play(type: .light)
            showShareDialog(messageLbl.text)
        }
    }
    
    private func setupConstraints() {
        let padding: CGFloat = 10
        leadingConstraint?.isActive = false
        trailingConstraint?.isActive = false
        
        if viewModel.iAmSender {
            leadingConstraint = bubbleBackgroundView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 100)
            trailingConstraint = bubbleBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding)
        } else {
            leadingConstraint = bubbleBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding)
            trailingConstraint = bubbleBackgroundView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -100)
        }
        NSLayoutConstraint.activate([
            bubbleBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            bubbleBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding),
            
            stackView.topAnchor.constraint(equalTo: bubbleBackgroundView.topAnchor, constant: padding),
            stackView.leadingAnchor.constraint(equalTo: bubbleBackgroundView.leadingAnchor, constant: padding),
            stackView.trailingAnchor.constraint(equalTo: bubbleBackgroundView.trailingAnchor, constant: -padding),
            stackView.bottomAnchor.constraint(equalTo: bubbleBackgroundView.bottomAnchor, constant: -padding),
            
            leadingConstraint!,
            trailingConstraint!
        ])
    }
    
    private func populateViews() {
        messageLbl.text = viewModel.message
        timestampLbl.text = viewModel.timestamp
    }
}

