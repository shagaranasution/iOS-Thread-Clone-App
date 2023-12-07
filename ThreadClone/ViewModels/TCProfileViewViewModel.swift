//
//  TCProfileViewViewModel.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 14/11/23.
//

import Foundation

protocol TCProfileViewViewModelDelegate: AnyObject {
    
    func didFetch(currentUser user: TCUser)
    
}

final class TCProfileViewViewModel {
    
    // MARK: - Private Methods
    
    private var userId: String
    private(set) var currentUser: TCUser?
    
    // MARK: - Public Methods
    
    public var delegate: TCProfileViewViewModelDelegate?
    
    public var fullName: String {
        return currentUser?.fullName ?? ""
    }
    
    public var username: String {
        return currentUser?.username ?? ""
    }
    
    public var bio: String {
        return currentUser?.bio ?? "-"
    }
    
    public var profilePictureImageUrl: String {
        return currentUser?.profileImageUrl ?? ""
    }
    
    // MARK: - Initialization
    
    init(
        userId: String
    ) {
        self.userId = userId
    }
    
    // MARK: - Public Methods
    
    public func fetchUser() {
        TCUserService.shared.fetchUser(withId: userId) { [weak self] result in
            switch result {
            case .success(let model):
                self?.currentUser = model
                self?.delegate?.didFetch(currentUser: model)
            case .failure(let error):
                print("Error fetching currentn user: \(error)")
                break
            }
        }
    }
    
}
