//
//  TCPagerTabCollectionViewCell.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 23/10/23.
//

import UIKit

protocol TCPagerTabItemProtocol: UIView {
    
    var contentInsets: UIEdgeInsets { get set }
    
    func onSelected()
    func onNotSelected()
    
}

final class TCPagerTabCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Static
    
    public static let identifier = "TCPagerTabCollectionViewCell"
    
    // MARK: - Private Properties
    
    private var view: TCPagerTabItemProtocol? {
        didSet {
            self.setupViews()
        }
    }
    
    private var topConstraint = NSLayoutConstraint()
    private var leftConstraint = NSLayoutConstraint()
    private var rightConstraint = NSLayoutConstraint()
    private var bottomConstraint = NSLayoutConstraint()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }
    
    // MARK: Private Methods
    
    private func setupViews() {
        guard let view = view else { return }
        contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        topConstraint = view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: view.contentInsets.top)
        leftConstraint = view.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: view.contentInsets.left)
        rightConstraint = view.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -view.contentInsets.right)
        bottomConstraint = view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -view.contentInsets.bottom)

        NSLayoutConstraint.activate([
            topConstraint,
            leftConstraint,
            rightConstraint,
            bottomConstraint
        ])
    }
    
    // MARK: Public Methods
    
    /// Method used to provide view for  cell.
    /// - Parameter view: a view, conforming to TCPagerTabItemProtocol,  presents content for cell.
    public func setView(_ view: TCPagerTabItemProtocol) {
        self.view = view
    }
    
}

extension TCPagerTabItemProtocol {
    
    var contentInsets: UIEdgeInsets {
        get {
            return  UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 0,
                right: 0
            )
        }
        set { }
    }
    
}
