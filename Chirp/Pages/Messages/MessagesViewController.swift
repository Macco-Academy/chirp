//
//  MessagesViewController.swift
//  Chirp
//
//  Created by Emmanuel Okwara on 11.06.23.
//

import UIKit
import Combine

class MessagesViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .textFieldBackground
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()
    private let textViewPlaceholder: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .lightGray
        label.text = "Type a message..."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let actionsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let separatorView = UIView()
        separatorView.backgroundColor = .textFieldBackground
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separatorView)
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.topAnchor.constraint(equalTo: view.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        return view
    }()
    private let actionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let sendBtnContainerView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let sendBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.sendMessagePlane, for: .normal)
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.backgroundColor = .appBrown
        button.tintColor = .white
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return button
    }()
    private var textViewHeightConstraint: NSLayoutConstraint?
    
    private let maxTextViewHeight: CGFloat = 200
    private var viewModel: MessagesViewModel!
    private var cancellables: Set<AnyCancellable> = []
    private var keyboardHeight: CGFloat = 0
    private var textViewBottomConstraint: NSLayoutConstraint?
    private var isDonePresenting = false
    
    init(viewModel: MessagesViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupListeners()
        viewModel.fetchMessages()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(actionsContainerView)
        actionsContainerView.addSubview(actionsStackView)
        actionsStackView.addArrangedSubview(textView)
        actionsStackView.addArrangedSubview(sendBtnContainerView)
        sendBtnContainerView.addSubview(sendBtn)
        textView.addSubview(textViewPlaceholder)
        navigationItem.largeTitleDisplayMode = .never
        title = "Chat"
        view.backgroundColor = .systemBackground
        setupTableView()
        setupTextView()
        sendBtn.addTarget(self, action: #selector(self.sendBtnClicked), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isDonePresenting = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.layer.cornerRadius = 20
        sendBtn.layer.cornerRadius = 20
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    private func setupTextView() {
        textView.addRoundedCorners(corners: .allCorners, radius: 10)
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.delegate = self
        textView.isScrollEnabled = true
    }
    
    private func setupConstraints() {
        textViewHeightConstraint = textView.heightAnchor.constraint(equalToConstant: textView.intrinsicContentSize.height)
        textViewHeightConstraint?.isActive = true
        textViewBottomConstraint = actionsContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        textViewBottomConstraint?.isActive = true
        let padding: CGFloat = actionsStackView.spacing
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            actionsContainerView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            actionsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            actionsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            actionsStackView.topAnchor.constraint(equalTo: actionsContainerView.topAnchor, constant: padding * 2),
            actionsStackView.leadingAnchor.constraint(equalTo: actionsContainerView.leadingAnchor, constant: padding),
            actionsStackView.trailingAnchor.constraint(equalTo: actionsContainerView.trailingAnchor, constant: -padding),
            actionsStackView.bottomAnchor.constraint(equalTo: actionsContainerView.bottomAnchor, constant:  -(padding * 2)),
            
            sendBtn.heightAnchor.constraint(equalToConstant: 40),
            sendBtn.widthAnchor.constraint(equalToConstant: 40),
            sendBtn.topAnchor.constraint(greaterThanOrEqualTo: sendBtnContainerView.topAnchor),
            sendBtn.leadingAnchor.constraint(equalTo: sendBtnContainerView.leadingAnchor),
            sendBtn.trailingAnchor.constraint(equalTo: sendBtnContainerView.trailingAnchor),
            sendBtn.bottomAnchor.constraint(equalTo: sendBtnContainerView.bottomAnchor),
            
            textViewPlaceholder.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            textViewPlaceholder.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 12),
            textViewPlaceholder.trailingAnchor.constraint(equalTo: textView.trailingAnchor, constant: -12)
        ])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.resetUnreadCount()
    }
    
    private func setupListeners() {
        viewModel.messages.sink { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
            if !self.viewModel.messages.value.isEmpty {
                self.scrollMessagesToBottom(animate: self.isDonePresenting)
            }
        }
        .store(in: &cancellables)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextView(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeKeyboardFrame), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
    }
    
    @objc private func didChangeKeyboardFrame() {
        scrollMessagesToBottom()
    }
    
    @objc private func sendBtnClicked(sender: UIButton) {
        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        viewModel.sendMessage(text)
        textView.text = ""
        refreshTextViewHeight()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MessagesViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textViewPlaceholder.isHidden = textView.text.isEmpty == false
        refreshTextViewHeight()
    }
    
    private func refreshTextViewHeight() {
        textViewHeightConstraint?.constant = min(textView.contentSize.height, maxTextViewHeight)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        refreshTextViewPosition()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        refreshTextViewPosition()
    }
    
    private func scrollMessagesToBottom(animate: Bool = true) {
        self.tableView.scrollToRow(at: IndexPath(row: self.viewModel.messages.value.count - 1, section: 0), at: .bottom, animated: animate)
    }
}

extension MessagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier) as! MessageTableViewCell
        let message = viewModel.messages.value[indexPath.row]
        cell.setup(viewModel: message)
        return cell
    }
}

// MARK: - Keyboard Handler
extension MessagesViewController {
    private func refreshTextViewPosition() {
        let keyboardActive = textView.isFirstResponder
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 6, options: [], animations: ({ [weak self] in
            guard let self = self else { return }
            self.textViewBottomConstraint?.constant = keyboardActive ? -(self.keyboardHeight - self.view.safeAreaInsets.bottom) : 0
            self.view.layoutIfNeeded()
        }), completion: nil)
    }
    
    @objc func updateTextView(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardEndFrameScreenCoordinates = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardEndFrame = self.view.convert(keyboardEndFrameScreenCoordinates, to: view.window)
        self.keyboardHeight = keyboardEndFrame.height
        self.refreshTextViewPosition()
    }
}
