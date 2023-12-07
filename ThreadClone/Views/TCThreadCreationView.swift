//
//  TCThreadCreationView.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 23/10/23.
//

import UIKit
import SDWebImage

protocol TCThreadCreationViewDelegate: AnyObject {
    
    func threadCreationView(_ view: TCThreadCreationView, textViewDidChange textView: UITextView)
    
    func threadCreationView(_ view: TCThreadCreationView, didUploadThread result: Result<TCThread, Error>)
    
}

final class TCThreadCreationView: UIView {
        
    // MARK: - UI
    
    private lazy var avatarImageView = TCAvatarImageView()
    
    // MARK: - Private Properties
    
    public var viewModel: TCThreadCreationViewViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            viewModel.delegate = self
            viewModel.fetchUser()
        }
    }
    
    // MARK: - Public Properties
    
    public weak var delegate: TCThreadCreationViewDelegate?
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private(set) lazy var threadTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.becomeFirstResponder()
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        return textView
    }()
    
    private lazy var threadPlacholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Start your thread.."
        label.textColor = .tertiaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(
            avatarImageView,
            usernameLabel,
            threadTextView,
            threadPlacholderLabel
        )
        addConstraints()
        threadTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Private Methods
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            usernameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            threadTextView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            threadTextView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 3),
            threadTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            threadPlacholderLabel.topAnchor.constraint(equalTo: threadTextView.topAnchor, constant: 0),
            threadPlacholderLabel.leadingAnchor.constraint(equalTo: threadTextView.leadingAnchor, constant: 6),
        ])
    }
    
    // MARK: - Public Methods
    
    public func updateUI() {
        guard let viewModel = viewModel else { return }
        usernameLabel.text = viewModel.username
        avatarImageView.sd_setImage(
            with: URL(string: viewModel.profilePictureImageUrl),
            placeholderImage: UIImage.init(systemName: "person.fill")
        )
    }
    
    
    
}

extension TCThreadCreationView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        threadPlacholderLabel.isHidden = !textView.text.isEmpty
        delegate?.threadCreationView(self, textViewDidChange: textView)
    }
    
}


extension TCThreadCreationView: TCThreadCreationViewViewModelDelegate {
    
    func didFetchCurrentUser() {
        updateUI()
    }
    
    func didUploadThread(result: Result<TCThread, Error>) {
        delegate?.threadCreationView(self, didUploadThread: result)
    }
    
}
