//
//  TCSearchViewViewModel.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 15/11/23.
//

import Foundation

protocol TCSearchViewViewModelDelegate: AnyObject {
    
    func didFetchUsers()
    
}

final class TCSearchViewViewModel {
    
    // MARK: - Private Properties
    
    private(set) var users: [TCUser] = []
    
    // MARK: - Public Properties
    
    public var delegate: TCSearchViewViewModelDelegate?
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - Public Methods
    
    public func fetchUsers() {
        TCUserService.shared.fetchUsers { [weak self] result in
            switch result {
            case .success(let model):
                self?.users = model
                self?.delegate?.didFetchUsers()
            case .failure(let error):
                print("Error fetching users: \(error)")
                break
            }
        }
    }
    
}
