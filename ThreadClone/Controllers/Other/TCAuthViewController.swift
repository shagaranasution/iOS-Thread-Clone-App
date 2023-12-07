//
//  TCAuthViewController.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 17/10/23.
//

import UIKit

final class TCAuthViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var authView: TCAuthView = {
        let view = TCAuthView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        
        return view
    }()
    
    // MARK: - UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(authView)
        addConstraints()
        
        authView.registerDidTapSignUpHandler { [weak self] in
            self?.presentRegistrationVC()
        }
    }
    
    // MARK: - Private Methods
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            authView.topAnchor.constraint(equalTo: view.topAnchor),
            authView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            authView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            authView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func presentRegistrationVC() {
        let vc = TCRegistrationViewController()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    private func showSignUpAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        
        present(alert, animated: true)
    }
    
}

// MARK: Extension TCAuthView Delegate

extension TCAuthViewController: TCAuthViewDelegate {
    
    func authView(_ view: TCAuthView, didSuccessfullySignIn result: Result<Bool, Error>) {
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
