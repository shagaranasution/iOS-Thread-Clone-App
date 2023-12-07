//
//  TCSearchTableViewCell.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 20/10/23.
//

import UIKit
import SDWebImage

final class TCSearchTableViewCell: UITableViewCell {
    
    static let identifier = "TCSearchTableViewCell"
    
    // MARK: - UI
    
    private lazy var avatarImageView = TCAvatarImageView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "chara"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Stephani Chara"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
            .foregroundColor: UIColor.label
        ]
        button.setAttributedTitle(
            NSAttributedString(
                string: "Follow",
                attributes: attributes
            ),
            for: .normal
        )
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 4
        button.layer.isOpaque = true
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 96).isActive = true
        
        return button
    }()
    
    // MARK: Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(
            avatarImageView,
            titleLabel,
            subtitleLabel,
            followButton
        )
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        avatarImageView.image = nil
    }
    
    // MARK: Private Methods
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            followButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            followButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            titleLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -2),
            titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: followButton.leadingAnchor, constant: -8),
            
            subtitleLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: followButton.leadingAnchor, constant: -8),
        ])
    }
    
    // MARK: Public Methods
    
    public func configure(with viewModel: TCSearchTableViewCellViewModel) {
        titleLabel.text = viewModel.fullName
        subtitleLabel.text = viewModel.username
        avatarImageView.sd_setImage(
            with: URL(string: viewModel.profilePictureImageUrl),
            placeholderImage: UIImage.init(systemName: "person.fill")
        )
    }
    
}
