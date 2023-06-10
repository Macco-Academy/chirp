//
//  ChatsTableViewCell.swift
//  Chirp
//
//  Created by Ady on 6/7/23.
//

import UIKit
import Kingfisher

class ChatsTableViewCell: UITableViewCell {
    
    // Constants
    private let imageViewWidth: CGFloat = 52
    private let labelHeight: CGFloat = 18
    private let leadingTrailingAnchor: CGFloat = 8
    static let identifier = "ChatsTableViewCell"
    
    lazy var friendImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Full Name"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    lazy var lastMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Message"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var lastMessageTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Message Time"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    lazy var unreadMessageCounterLabel: UILabel = {
        let label = UILabel()
        label.text = "10"
        label.textColor = .white
        label.backgroundColor = .red
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    // Cell boundary view
    private let cellBoundaryview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Setup tableview cell
    func setup(viewModel: ChatsListViewModel) {
        populateData(viewModel: viewModel)
        setupViews()
        setupConstraints()
    }
    
    private func populateData(viewModel: ChatsListViewModel) {
        fullNameLabel.text = viewModel.title
        lastMessageLabel.text = viewModel.description
        lastMessageTimeLabel.text = viewModel.timeStamp?.asTimeAgo
        unreadMessageCounterLabel.text = "\(viewModel.unreadCount ?? 0)"
        unreadMessageCounterLabel.alpha = unreadMessageCounterLabel.text == "0" ? 0 : 1
        friendImageView.kf.setImage(with: URL(string: viewModel.imageUrl ?? ""), placeholder: UIImage.placeholderImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        friendImageView.layer.cornerRadius = friendImageView.frame.width/2
        unreadMessageCounterLabel.layer.cornerRadius = unreadMessageCounterLabel.frame.width/2
        
    }
    
    // Add subviews
    private func setupViews() {
        addSubview(cellBoundaryview)
        addSubview(friendImageView)
        addSubview(fullNameLabel)
        addSubview(lastMessageLabel)
        addSubview(lastMessageTimeLabel)
        addSubview(unreadMessageCounterLabel)
    }
    
    // Configure constraints for the subviews
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cellBoundaryview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            cellBoundaryview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            cellBoundaryview.topAnchor.constraint(equalTo: topAnchor),
            cellBoundaryview.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellBoundaryview.heightAnchor.constraint(greaterThanOrEqualToConstant: imageViewWidth + 20),
            
            friendImageView.leadingAnchor.constraint(equalTo: cellBoundaryview.leadingAnchor),
            friendImageView.centerYAnchor.constraint(equalTo: cellBoundaryview.centerYAnchor),
            friendImageView.widthAnchor.constraint(equalToConstant: imageViewWidth),
            friendImageView.heightAnchor.constraint(equalToConstant: imageViewWidth),
            
            fullNameLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: leadingTrailingAnchor),
            fullNameLabel.trailingAnchor.constraint(equalTo: lastMessageTimeLabel.leadingAnchor, constant: -4),
            fullNameLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            fullNameLabel.topAnchor.constraint(equalTo: friendImageView.topAnchor, constant: leadingTrailingAnchor),
            
            lastMessageTimeLabel.trailingAnchor.constraint(equalTo: cellBoundaryview.trailingAnchor),
            lastMessageTimeLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            lastMessageTimeLabel.topAnchor.constraint(equalTo: fullNameLabel.topAnchor),
            
            lastMessageLabel.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: leadingTrailingAnchor),
            lastMessageLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            lastMessageLabel.bottomAnchor.constraint(equalTo: friendImageView.bottomAnchor, constant: -leadingTrailingAnchor),
            
            unreadMessageCounterLabel.trailingAnchor.constraint(equalTo: cellBoundaryview.trailingAnchor),
            unreadMessageCounterLabel.heightAnchor.constraint(equalToConstant: labelHeight),
            unreadMessageCounterLabel.widthAnchor.constraint(equalToConstant: labelHeight),
            unreadMessageCounterLabel.bottomAnchor.constraint(equalTo: friendImageView.bottomAnchor, constant: -leadingTrailingAnchor)
        ])
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
