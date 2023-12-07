//
//  TCTextField.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 17/10/23.
//

import UIKit

class TCTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 12,
                               left: 16,
                               bottom: 12,
                               right: 16)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

}
