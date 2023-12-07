//
//  Extensions.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 17/10/23.
//

import UIKit

// MARK: - Extension UIView

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
    
}

// MARK: - Extension UIView

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
    
}

// MARK: - Extension Notificatioin Name

extension Notification.Name {
    
    static let threadPostedNotification = Notification.Name("threadPostedNotification")
    static let profileUpdatedNotification = Notification.Name("profileUpdatedNotification")
    
}
