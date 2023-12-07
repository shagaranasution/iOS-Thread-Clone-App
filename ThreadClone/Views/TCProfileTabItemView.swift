//
//  TCProfileTabItemView.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 31/10/23.
//

import UIKit

final class TCProfileTabItemView: UIView, TCPagerTabItemProtocol {
    
    // MARK: - UI
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .secondaryLabel
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Private Properties
    
    private let title: String
    
    // MARK: - Public Properties
    
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
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func onSelected() {
        titleLabel.textColor = .label
        
        if borderView.superview == nil {
            addSubview(borderView)
            
            NSLayoutConstraint.activate([
                borderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                borderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
                borderView.heightAnchor.constraint(equalToConstant: 2),
            ])
        }
    }
    
    func onNotSelected() {
        titleLabel.textColor = .secondaryLabel
        layer.shadowOpacity = 0
        borderView.removeFromSuperview()
    }
    
}
