//
//  TCAvatarImageView.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 20/10/23.
//

import UIKit

class TCAvatarImageView: UIImageView {
    
    // MARK: Private Properties
    
    private(set) var imageSize: CGFloat = 36
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    // MARK: - Private Methods
    
    private func setupView() {
        image = UIImage(systemName: "person.fill")
        contentMode = .scaleAspectFill
        backgroundColor = .systemGray
        layer.cornerRadius = imageSize/2
        clipsToBounds = true
        tintColor = .label
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        heightAnchor.constraint(equalToConstant: imageSize).isActive = true
    }
    
    // MARK: - Public Methods
    
    public func setImageSize(to size: CGFloat) {
        self.imageSize = size
    }
    
}
