//
//  TCProfileView.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 16/11/23.
//

import UIKit
import SDWebImage

protocol TCProfileViewDelegate: AnyObject {
    
    func didTapEditProfileButton()
    
}

final class TCProfileView: UIView {
    
    // MARK: - Private Properties
    
    private lazy var safeAreaTopHeight: CGFloat = {
        return safeAreaInsets.top
    }()
    
    // MARK: - Public Properties
    
    public weak var delegate: TCProfileViewDelegate?
    
    public var viewModel: TCProfileViewViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            viewModel.delegate = self
            fetchData()
        }
    }
    
    public lazy var threadsVC = TCThreadsViewController(
        withViewModel: TCThreadsViewViewModel(withCurrentUserId: TCAuthService.shared.userUid)
    )
    public lazy var repliesVC = TCThreadsViewController(
        withViewModel: TCThreadsViewViewModel(withCurrentUserId: TCAuthService.shared.userUid)
    )
    
    // MARK: - UI
    
    private lazy var avatarImageView = TCAvatarImageView()
    
    private lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        label.clipsToBounds = true
        
        return label
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.clipsToBounds = true
        
        return label
    }()
    
    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 3
        label.clipsToBounds = true
        
        return label
    }()
    
    private lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.shadowColor = .none
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowOpacity = 0
        button.addTarget(self, action: #selector(editProfileTap), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.addSubviews(
            fullNameLabel,
            usernameLabel,
            bioLabel,
            avatarImageView,
            editProfileButton
        )
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 128),
            
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            fullNameLabel.topAnchor.constraint(equalTo: view.topAnchor),
            fullNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            fullNameLabel.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: -16),
            
            usernameLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 8),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: -16),
            
            bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 12),
            bioLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            editProfileButton.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 16),
            editProfileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            editProfileButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

        ])
        
        return view
    }()
    
    private lazy var pagerView: TCPagerView = {
        let pagerView = TCPagerView(
            headerView: headerView,
            tabSizeConfiguration: .fillEqually(height: 56, spacing: 8)
        )
        pagerView.translatesAutoresizingMaskIntoConstraints = false
        
        let threadTabItem = TCProfileTabItemView(title: "Threads")
        let replyTabItem = TCProfileTabItemView(title: "Replies")
       
        pagerView.tabsView.setTabs([
            threadTabItem,
            replyTabItem
        ])
        
        pagerView.pagesView.setPages([
            threadsVC.view,
            repliesVC.view
        ])
        
        
        threadsVC.registerDidScrollTableViewHandler { [weak self] contentOffset in
            guard let self = self else { return }
            
            let saafeAreaTopHeight = safeAreaTopHeight
            
            if contentOffset.y > 0 && pagerView.contentOffset.y <= 0 {
                pagerView.contentOffset.y += contentOffset.y
            }
            
            if contentOffset.y < 0 {
                pagerView.contentOffset.y = saafeAreaTopHeight * -1
            }
        }
        repliesVC.registerDidScrollTableViewHandler { [weak self] contentOffset in
            guard let self = self else { return }
            
            let saafeAreaTopHeight = safeAreaTopHeight
            
            if contentOffset.y > 0 && pagerView.contentOffset.y <= 0 {
                pagerView.contentOffset.y += contentOffset.y
            }
            
            if contentOffset.y < 0 {
                pagerView.contentOffset.y = saafeAreaTopHeight * -1
            }
            
        }
        
        return pagerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(pagerView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }
    
    // MARK: - Private Methods
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            pagerView.topAnchor.constraint(equalTo: topAnchor),
            pagerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pagerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pagerView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    @objc
    private func editProfileTap() {
        delegate?.didTapEditProfileButton()
    }
    
    private func fetchData() {
        viewModel?.fetchUser()
    }
    
    private func updateUI(with viewModel: TCProfileViewViewModel) {
        fullNameLabel.text = viewModel.fullName
        usernameLabel.text = viewModel.username
        bioLabel.text = viewModel.bio
        avatarImageView.sd_setImage(
            with: URL(string: ""),
            placeholderImage: UIImage.init(systemName: "person.fill")
        )
    }
    
}

// MARK: - Extension TCProfileViewViewModel Delegate

extension TCProfileView: TCProfileViewViewModelDelegate {
    
    func didFetch(currentUser user: TCUser) {
        guard let viewModel = viewModel else { return }
        fullNameLabel.text = viewModel.fullName
        usernameLabel.text = viewModel.username
        bioLabel.text = viewModel.bio
        avatarImageView.sd_setImage(
            with: URL(string: viewModel.profilePictureImageUrl),
            placeholderImage: UIImage.init(systemName: "person.fill")
        )
    }
    
}
