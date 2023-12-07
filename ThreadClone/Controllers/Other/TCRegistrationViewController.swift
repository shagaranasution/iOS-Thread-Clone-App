//
//  TCRegistrationViewController.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 18/10/23.
//

import UIKit

final class TCRegistrationViewController: UIViewController {
    
    // MARK: - UI
    
    private lazy var registrationView: TCRegistrationView = {
        let view = TCRegistrationView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    // MARK: - UIViewControlller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        registrationView.registerDidTapSignInHandler { [weak self] in
            self?.dismissViewController()
        }
    }
    
    // MARK: - Private Methods
    
    private func dismissViewController() {
        dismiss(animated: true)
    }
    
    private func setupViews() {
        view.addSubview(registrationView)
        NSLayoutConstraint.activate([
            registrationView.topAnchor.constraint(equalTo: view.topAnchor),
            registrationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            registrationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            registrationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func showSignUpAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        present(alert, animated: true)
    }
    
}

// MARK: Extension TCRegistrationView Delegate

extension TCRegistrationViewController: TCRegistrationViewDelegate {
    
    func registrationView(_ view: TCRegistrationView, didSuccessfullySignUp result: Result<Bool, Error>) {
        switch result {
        case .success:
            DispatchQueue.main.async { [weak self] in
                let vc = TCTabBarViewController()
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: true)
            }
        case .failure(let error):
            DispatchQueue.main.async { [weak self] in
                self?.showSignUpAlert(withMessage: error.localizedDescription)
            }
        }
    }
    
}
