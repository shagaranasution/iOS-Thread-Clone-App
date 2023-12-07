//
//  TCEditCurrentProfileViewController.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 01/12/23.
//

import UIKit
import PhotosUI

final class TCEditCurrentProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let viewModel: TCEditCurrentProfileViewViewModel
    
    private lazy var editCurrentProfileView: TCEditCurrentProfileView = {
        let view = TCEditCurrentProfileView(viewModel: viewModel)
        
        return view
    }()
    
    // MARK: - Initialization
    
    init(withViewModel viewModel: TCEditCurrentProfileViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Profile"
        setupNavigationView()
        view.addSubview(editCurrentProfileView)
        addConstraints()
        editCurrentProfileView.delegate = self
    }
    
    // MARK: - Private Methods
    
    @objc
    private func tapLeftBarButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func tapRightBarButton() {
        guard let fullName = editCurrentProfileView.nameTextField.text else {
            return
        }
        
        viewModel.updateUserData(
            withFullName: fullName,
            bio: editCurrentProfileView.bioTextField.text,
            link: editCurrentProfileView.linkTextField.text,
            image: editCurrentProfileView.profileImageView.image
        ) { [weak self] isSuccess in
            guard isSuccess else { return }
            NotificationCenter.default.post(
                name: .profileUpdatedNotification,
                object: nil
            )
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }
    }
    
    private func setupNavigationView() {
        navigationController?.navigationBar.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(tapLeftBarButton)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(tapRightBarButton)
        )
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            editCurrentProfileView.topAnchor.constraint(equalTo: view.topAnchor),
            editCurrentProfileView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            editCurrentProfileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editCurrentProfileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
}

// MARK: - Extension TCEditCurrentProfileView Delegate

extension TCEditCurrentProfileViewController: TCEditCurrentProfileViewDelegate {
    
    func didTapProfileImageView(_ viewController: PHPickerViewController) {
        present(viewController, animated: true)
    }
    
    func didFinishPickingImage() {
        dismiss(animated: true)
    }
    
}
