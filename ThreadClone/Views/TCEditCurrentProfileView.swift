//
//  TCEditCurrentProfileView.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 04/12/23.
//

import UIKit
import PhotosUI
import SDWebImage

protocol TCEditCurrentProfileViewDelegate: AnyObject {
    
    func didTapProfileImageView(_ picker: PHPickerViewController)
    func didFinishPickingImage()
    
}

final class TCEditCurrentProfileView: UIView {
    
    // MARK: - UI
    
    private lazy var picker: PHPickerViewController = {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        return picker
    }()
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray3.cgColor
        view.layer.shadowColor = .none
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        
        return view
    }()
    
    public lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemGray
        imageView.image = UIImage(systemName: "person.fill")
        imageView.clipsToBounds = true
        imageView.tintColor = .label
        imageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        imageView.layer.cornerRadius = 44/2
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.text = "Name"
        
        return label
    }()
    
    public lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your name..."
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.text = "Bio"
        
        return label
    }()
    
    public lazy var bioTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your bio..."
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.text = "Link"
        
        return label
    }()
    
    public lazy var linkTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Add link..."
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var nameSeparatorView: UIView = createSeparatorView()
    
    private lazy var bioSeparatorView: UIView = createSeparatorView()
    
    private lazy var linkSeparatorView: UIView = createSeparatorView()
    
    // MARK: - Public Properties
    
    public var delegate: TCEditCurrentProfileViewDelegate?
    
    // MARK: - Private Properties
    
    private let viewModel: TCEditCurrentProfileViewViewModel
    
    // MARK: - Initializationn
    
    init(viewModel: TCEditCurrentProfileViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        setupViews()
        setupGestures()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func createSeparatorView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3
        
        return view
    }
    
    @objc
    private func tapProfileImageView() {
        delegate?.didTapProfileImageView(picker)
    }
    
    private func setupGestures() {
        let profileImageTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(tapProfileImageView)
        )
        profileImageView.addGestureRecognizer(profileImageTapGesture)
    }
    
    private func setupViews() {
        addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
        
        cardView.addSubviews(
            nameLabel,
            nameTextField,
            profileImageView,
            nameSeparatorView,
            bioLabel,
            bioTextField,
            bioSeparatorView,
            linkLabel,
            linkTextField,
            linkSeparatorView
        )
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            profileImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: -8),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: -8),
            
            nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            nameSeparatorView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            nameSeparatorView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            nameSeparatorView.heightAnchor.constraint(equalToConstant: 0.7),
            
            bioLabel.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            bioLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            bioTextField.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 8),
            bioTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            bioTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            bioSeparatorView.topAnchor.constraint(equalTo: bioTextField.bottomAnchor, constant: 8),
            bioSeparatorView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            bioSeparatorView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            bioSeparatorView.heightAnchor.constraint(equalToConstant: 0.7),
            
            linkLabel.topAnchor.constraint(equalTo: bioSeparatorView.bottomAnchor, constant: 8),
            linkLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            linkLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            linkTextField.topAnchor.constraint(equalTo: linkLabel.bottomAnchor, constant: 8),
            linkTextField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            linkTextField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            linkSeparatorView.topAnchor.constraint(equalTo: linkTextField.bottomAnchor, constant: 8),
            linkSeparatorView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8),
            linkSeparatorView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            linkSeparatorView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            linkSeparatorView.heightAnchor.constraint(equalToConstant: 0.7),
        ])
    }
    
    private func updateUI() {
        nameTextField.text = viewModel.fullName
        bioTextField.text = viewModel.bio
        linkTextField.text = viewModel.link
        profileImageView.sd_setImage(
            with: URL(string: viewModel.profileImageUrl ?? ""),
            placeholderImage: UIImage.init(systemName: "person.fill")
        )
    }
    
}

// MARK: - Extension UITextField Delegate

extension TCEditCurrentProfileView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
}

// MARK: - Extension PHPickerViewController Delegate

extension TCEditCurrentProfileView: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        delegate?.didFinishPickingImage()
        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else {
            return
        }
        
        itemProvider.loadObject(
            ofClass: UIImage.self
        ) { [weak self] image, error in
            guard let selectedImage = image as? UIImage,
                  error == nil else {
                print("Error picking image from photo galery: \(error!)")
                return
            }
            
            DispatchQueue.main.async {
                self?.profileImageView.image = selectedImage
            }
        }
    }
    
}
