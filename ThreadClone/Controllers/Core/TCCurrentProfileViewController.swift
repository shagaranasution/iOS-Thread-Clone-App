//
//  TCCurrentProfileViewController.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 19/10/23.
//

import UIKit

final class TCCurrentProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    // MARK: - UI
    
    private lazy var profileView = TCProfileView()
    private let viewModel = TCProfileViewViewModel(userId: TCAuthService.shared.userUid ?? "")
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.viewModel = viewModel
        profileView.delegate = self
        setupViews()
        addChildren()
        setupNotificationCenterAddition()
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        setupNavigationRightBarButtonItem()
        
        view.addSubview(profileView)
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc
    private func tapRightBarButton() {
        TCAuthService.shared.signOut { [weak self] isSuccess in
            guard isSuccess else {
                return
            }
            
            DispatchQueue.main.async {
                let vc = TCAuthViewController()
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: true)
            }
        }
    }
    
    private func setupNavigationRightBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal", withConfiguration: UIImage.SymbolConfiguration(pointSize: 16)),
            style: .plain,
            target: self,
            action: #selector(tapRightBarButton)
        )
    }

    private func addChildren() {
        addChild(profileView.threadsVC)
        profileView.threadsVC.didMove(toParent: self)
        addChild(profileView.repliesVC)
        profileView.repliesVC.didMove(toParent: self)
    }
    
    @objc private func handleProfileUpdatedNotification() {
        viewModel.fetchUser()
    }
    
    private func setupNotificationCenterAddition() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleProfileUpdatedNotification),
            name: .profileUpdatedNotification,
            object: nil
        )
    }
    
}

// MARK: Extension TCProfileView Delegate

extension TCCurrentProfileViewController: TCProfileViewDelegate {
    
    func didTapEditProfileButton() {
        guard let user = viewModel.currentUser else { return }
        let viewModel = TCEditCurrentProfileViewViewModel(user: user)
        let vc = UINavigationController(
            rootViewController: TCEditCurrentProfileViewController(withViewModel: viewModel)
        )
        present(vc, animated: true)
    }
    
}
