//
//  TCAuthView.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 17/10/23.
//

import UIKit

protocol TCAuthViewDelegate: AnyObject {
    
    func authView(_ view: TCAuthView, didSuccessfullySignIn result: Result<Bool, Error>)
    
}

final class TCAuthView: UIView {
    
    // MARK: Private Properties
    
    private var viewModel = TCAuthViewViewModel()
    private var didTapSignUpHandler: (() -> Void)?
    
    // MARK: public Properties
    
    public var delegate: TCAuthViewDelegate?
    
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
    
    private lazy var textFieldsContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private lazy var forgotPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Password?"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .right
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.tertiaryLabel, for: .disabled)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.addTarget(self, action: #selector(tapLoginButton), for: .touchUpInside)
        
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
        label.text = "Don't have an account?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textAlignment = .right
        
        return label
    }()
    
    private lazy var signUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Private Methods
    
    @objc
    private func tapForgotPasswordLabel() {
        print("Handle forgot password")
    }
    
    @objc
    private func tapLoginButton() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else { return }
        
        viewModel.signIn(
            withEmail: email,
            password: password
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.delegate?.authView(self, didSuccessfullySignIn: .success(true))
            case .failure(let error):
                self.delegate?.authView(self, didSuccessfullySignIn: .failure(error))
            }
        }
    }
    
    @objc
    private func tapSignUpLabel() {
        self.didTapSignUpHandler?()
    }
    
    @objc
    private func textFieldDidChange() {
        let isEmailNotEmpty = !(emailTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        let isPasswordNotEmpty = !(passwordTextField.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true)
        
        loginButton.isEnabled = isEmailNotEmpty && isPasswordNotEmpty
        loginButton.backgroundColor = loginButton.isEnabled ? .systemGray4 : .systemGray6
    }
    
    private func setupGestures() {
        let forgotPasswordTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(tapForgotPasswordLabel)
        )
        forgotPasswordLabel.addGestureRecognizer(forgotPasswordTapGesture)
        
        let signUpTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(tapSignUpLabel)
        )
        signUpLabel.addGestureRecognizer(signUpTapGesture)
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
            passwordTextField
        )
        
        addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.bottomAnchor.constraint(equalTo: textFieldsContainerView.topAnchor, constant: -32),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        addSubview(forgotPasswordLabel)
        NSLayoutConstraint.activate([
            forgotPasswordLabel.topAnchor.constraint(equalTo: textFieldsContainerView.bottomAnchor, constant: 16),
            forgotPasswordLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: forgotPasswordLabel.bottomAnchor, constant: 16),
            loginButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 45),
        ])
        
        addSubview(suggestionContainerView)
        NSLayoutConstraint.activate([
            suggestionContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            suggestionContainerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
        suggestionContainerView.addArrangedSubviews(
            suggestionLabel,
            signUpLabel
        )
        
        addSubview(dividerView)
        NSLayoutConstraint.activate([
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.bottomAnchor.constraint(equalTo: suggestionContainerView.topAnchor, constant: -16)
        ])
    }
    
    // MARK: - Public Methods
    
    public func registerDidTapSignUpHandler(_ block: @escaping () -> Void) {
        self.didTapSignUpHandler = block
    }
    
}

// MARK: - Extension UITextField Delegate

extension TCAuthView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
