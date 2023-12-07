//
//  TCRegistrationView.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 18/10/23.
//

import UIKit

protocol TCRegistrationViewDelegate: AnyObject {
    
    func registrationView(_ view: TCRegistrationView, didSuccessfullySignUp result: Result<Bool, Error>)
    
}

final class TCRegistrationView: UIView {
    
    // MARK: - Private Properties
    
    private var didTapSignInHandler: (() -> Void)?
    private let viewModel = TCRegistrationViewViewModel()
    
    // MARK: - Public Methods
    
    public var delegate: TCRegistrationViewDelegate?
    
    // MARK: - UI
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tc_logo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageSize: CGFloat = 85
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        return imageView
    }()
    
    private lazy var emailTextField: TCTextField = {
        let textField = TCTextField()
        textField.placeholder = "Enter your email"
        textField.backgroundColor = .systemGray6
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.delegate = self
        textField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        
        return textField
    }()
    
    private lazy var passwordTextField: TCTextField = {
        let textField = TCTextField()
        textField.placeholder = "Enter your password"
        textField.backgroundColor = .systemGray6
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.delegate = self
        textField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        
        return textField
    }()
    
    private lazy var fullNameTextField: TCTextField = {
        let textField = TCTextField()
        textField.placeholder = "Enter your full name"
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.delegate = self
        textField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        
        return textField
    }()
    
    private lazy var usernameTextField: TCTextField = {
        let textField = TCTextField()
        textField.placeholder = "Enter your username"
        textField.autocapitalizationType = .none
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.delegate = self
        textField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        
        return textField
    }()
    
    private lazy var textFieldsContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.tertiaryLabel, for: .disabled)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        return view
    }()
    
    private lazy var suggestionContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var suggestionLabel: UILabel = {
        let label = UILabel()
        label.text = "Already have an account?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var signInLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .left
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupViews()
        setupGestures()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }
    
    // MARK: - Private Methods
    
    @objc
    private func textFieldDidChange() {
        let isEmailNotEmpty = !(emailTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        let isPasswordNotEmpty = !(passwordTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? false)
        let isFullNameNotEmpty = !(fullNameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        let isUsernameNotEmpty = !(usernameTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        
        signUpButton.isEnabled = isEmailNotEmpty && isPasswordNotEmpty && isFullNameNotEmpty && isUsernameNotEmpty
        signUpButton.backgroundColor = signUpButton.isEnabled ? .systemGray4 : .systemGray6
    }
    
    @objc
    private func tapSignInLabel() {
        self.didTapSignInHandler?()
    }
    
    @objc
    private func tapSignUpButton() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let fullName = fullNameTextField.text,
              let username = usernameTextField.text else {
            return
        }
        
        viewModel.createUser(
            email: email,
            password: password,
            fullName: fullName,
            username: username
        ) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.delegate?.registrationView(self, didSuccessfullySignUp: .success(true))
            case .failure(let error):
                self.delegate?.registrationView(self, didSuccessfullySignUp: .failure(error))
            }
        }
    }
    
    private func setupGestures() {
        let signInTapGestures = UITapGestureRecognizer(
            target: self,
            action: #selector(tapSignInLabel)
        )
        signInLabel.addGestureRecognizer(signInTapGestures)
    }
    
    private func setupActions() {
        signUpButton.addTarget(self, action: #selector(tapSignUpButton), for: .touchUpInside)
    }
    
    private func setupViews() {
        addSubview(textFieldsContainerView)
        NSLayoutConstraint.activate([
            textFieldsContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textFieldsContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textFieldsContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        textFieldsContainerView.addArrangedSubviews(
            emailTextField,
            passwordTextField,
            fullNameTextField,
            usernameTextField
        )
        
        addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.bottomAnchor.constraint(equalTo: textFieldsContainerView.topAnchor, constant: -32),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(equalTo: textFieldsContainerView.bottomAnchor, constant: 16),
            signUpButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            signUpButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            signUpButton.heightAnchor.constraint(equalToConstant: 45),
        ])
        
        addSubview(suggestionContainerView)
        NSLayoutConstraint.activate([
            suggestionContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            suggestionContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
        suggestionContainerView.addArrangedSubviews(
            suggestionLabel,
            signInLabel
        )
        
        addSubview(dividerView)
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: suggestionContainerView.topAnchor, constant: -16)
        ])
    }
    
    // MARK: - Public Methods
    
    public func registerDidTapSignInHandler(_ block: @escaping () -> Void) {
        self.didTapSignInHandler = block
    }
    
}

// MARK: - Extension UITextField Delegate

extension TCRegistrationView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
