//
//  TCProfileViewController.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 16/11/23.
//

import UIKit

final class TCProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let userId: String
    private lazy var viewModel = TCProfileViewViewModel(userId: userId)
    
    // MARK: - UI
    
    private lazy var profileView = TCProfileView()
    
    // MARK: - Initialization
    
    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addChildren()
        profileView.viewModel = viewModel
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {        
        view.addSubview(profileView)
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: view.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func addChildren() {
        addChild(profileView.threadsVC)
        profileView.threadsVC.didMove(toParent: self)
        addChild(profileView.repliesVC)
        profileView.repliesVC.didMove(toParent: self)
    }
    
}
