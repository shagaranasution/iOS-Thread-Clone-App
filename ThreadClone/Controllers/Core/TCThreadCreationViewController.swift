//
//  TCThreadCreationViewController.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 19/10/23.
//

import UIKit

final class TCThreadCreationViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var threadCreationView = TCThreadCreationView()
    
    // MARK: - Private Properties
    
    private let viewModel = TCThreadCreationViewViewModel()
    private var isPostEnabled = false
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "New Thread"
        setupBarButtonItems()
        view.addSubview(threadCreationView)
        addConstraints()
        threadCreationView.viewModel = viewModel
        threadCreationView.delegate = self
    }
    
    // MARK: - Private Methods
    
    @objc
    private func tapLeftBarButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func tapRightBarButton() {
        guard let caption = threadCreationView.threadTextView.text else { return }
        viewModel.uploadThread(withCaption: caption)
    }
    
    private func setupBarButtonItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(tapLeftBarButton)
        )
        navigationItem.leftBarButtonItem?.tintColor = .label
        
        navigationItem.rightBarButtonItem =  UIBarButtonItem(
            title: "Post",
            style: .done,
            target: self,
            action: #selector(tapRightBarButton)
        )
        navigationItem.rightBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem?.isEnabled = isPostEnabled
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            threadCreationView.topAnchor.constraint(equalTo: view.topAnchor),
            threadCreationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            threadCreationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            threadCreationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - Public Methods
    
    public func setIsPostEnabled(to isEnabled: Bool) {
        self.isPostEnabled = isEnabled
    }
    
}

extension TCThreadCreationViewController: TCThreadCreationViewDelegate {
    
    func threadCreationView(_ view: TCThreadCreationView, textViewDidChange textView: UITextView) {
        let isPostEnabled = textView.text.trimmingCharacters(in: .whitespaces).count > 0
        setIsPostEnabled(to: isPostEnabled)
        navigationItem.rightBarButtonItem?.isEnabled = isPostEnabled
    }
    
    func threadCreationView(_ view: TCThreadCreationView, didUploadThread result: Result<TCThread, Error>) {
        switch result {
        case .success:
            dismiss(animated: true)
            NotificationCenter.default.post(name: .threadPostedNotification, object: nil)
        case .failure:
            break
        }
    }
    
}
