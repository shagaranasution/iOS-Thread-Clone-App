//
//  TCPagerPageCollectionViewCell.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 23/10/23.
//

import UIKit

final class TCPagerPageCollectionViewCell: UICollectionViewCell {
    
    // MARK: Static
    
    public static let identifier = "TCPagerPageCollectionViewCell"
    
    // MARK: - UI
    
    private var view: UIView? {
        didSet {
            self.setupViews()
        }
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }
    
    // MARK: - Private Methods
    
    private func setupViews() {
        guard let view = view else { return }
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    // MARK: - Public Methods
    
    /// Method used to provide view for  cell.
    /// - Parameter view: a view presenting content for cell.
    public func setView(_ view: UIView) {
        self.view = view
    }
    
}
