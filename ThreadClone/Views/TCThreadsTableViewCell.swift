//
//  TCThreadsTableViewCell.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 19/10/23.
//

import UIKit
import SDWebImage

final class TCThreadsTableViewCell: UITableViewCell {
    
    static let identifier = "TCThreadsTableViewCell"
    
    // MARK: - UI
    
    private lazy var avatarImageView = TCAvatarImageView()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "chara"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var threadContentLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. In hendrerit ornare posuere. Aliquam et laoreet elit. Vivamus ac dapibus lorem, at lacinia dui. Ut at turpis ut sem accumsan venenatis eget eget diam. Praesent ullamcorper feugiat venenatis. Ut ac lacus ornare, consequat elit quis sodales sed. "
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var threadCreatedTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "10m"
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var moreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(
            systemName: "ellipsis",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 14,
                weight: .regular
            )
        )
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        return imageView
    }()
    
    private lazy var buttonsContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(
            systemName: "heart",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 16,
                weight: .regular
            ))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var replyButton: UIButton = {
        let button = UIButton()
        let image = UIImage(
            systemName: "bubble.right",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 16,
                weight: .regular
            ))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var repostButton: UIButton = {
        let button = UIButton()
        let image = UIImage(
            systemName: "arrow.rectanglepath",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 16,
                weight: .regular
            ))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        let image = UIImage(
            systemName: "paperplane",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 16,
                weight: .regular
            ))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        addSubviews(
            avatarImageView,
            usernameLabel,
            threadContentLabel,
            threadCreatedTimeLabel,
            moreImageView,
            buttonsContainerStackView
        )
        addConstraints()
        setupButtonsContainerStackViewChildren()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        usernameLabel.text = nil
//        threadContentLabel.text = nil
    }
    
    // MARK: - Private Methods
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            moreImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            moreImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            threadCreatedTimeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            threadCreatedTimeLabel.trailingAnchor.constraint(equalTo: moreImageView.leadingAnchor, constant: -8),
            
            usernameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            usernameLabel.trailingAnchor.constraint(equalTo: threadCreatedTimeLabel.leadingAnchor, constant: -8),
            
            threadContentLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            threadContentLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            threadContentLabel.trailingAnchor.constraint(equalTo: threadCreatedTimeLabel.leadingAnchor, constant: -8),
            
            buttonsContainerStackView.topAnchor.constraint(equalTo: threadContentLabel.bottomAnchor, constant: 16),
            buttonsContainerStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            buttonsContainerStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
    
    private func setupButtonsContainerStackViewChildren() {
        buttonsContainerStackView.addArrangedSubviews(
            likeButton,
            replyButton,
            repostButton,
            shareButton
        )
    }
    
    // MARK: - Public Methods
    
    public func configure(with viewModel: TCThreadsTableViewCellViewModel) {
        usernameLabel.text = viewModel.username
        threadContentLabel.text = viewModel.threadCaption
        avatarImageView.sd_setImage(
            with: URL(string: viewModel.profilePictureImageUrl),
            placeholderImage: UIImage.init(systemName: "person.fill")
        )
        threadCreatedTimeLabel.text = viewModel.threadCreatedDateString
    }
    
}
