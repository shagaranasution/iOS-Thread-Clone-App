//
//  TCSearchTableViewCellViewModel.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 15/11/23.
//

import Foundation

final class TCSearchTableViewCellViewModel {
    
    // MARK: Private Properties
    
    private let user: TCUser
    
    // MARK: Public Methods
    
    public var fullName: String {
        return user.fullName
    }
    
    public var username: String {
        return user.username
    }
    
    public var profilePictureImageUrl: String {
        return user.profileImageUrl ?? ""
    }
    
    // MARK: Initialization
    
    init(user: TCUser) {
        self.user = user
    }
    
}
