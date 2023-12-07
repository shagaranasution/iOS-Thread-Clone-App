//
//  TCActivityTabItemView.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 24/10/23.
//

import UIKit

final class TCActivityTabItemView: UIView, TCPagerTabItemProtocol {
    
    // MARK: - UI
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Private Properties
    
    private let title: String
    
    // MARK: - Public Properties
    
    public var contentInsets: UIEdgeInsets = UIEdgeInsets(
        top: 0,
        left: 16,
        bottom: 0,
        right: -16
    )
    
    // MARK: - Initialization
    
    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        addSubview(titleLabel)
        layer.cornerRadius = 10
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.systemGray3.cgColor
        layer.shadowOpacity = 0
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func onSelected() {
        backgroundColor = .systemGray
        layer.borderWidth = 0
        layer.borderColor = .none
        layer.shadowOpacity = 0
        titleLabel.textColor = .systemGray6
    }
    
    func onNotSelected() {
        backgroundColor = .systemBackground
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.systemGray3.cgColor
        layer.shadowOpacity = 0
        titleLabel.textColor = .label
    }
    
}
