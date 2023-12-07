//
//  TCThreadCreationViewViewModel.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 17/11/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol TCThreadCreationViewViewModelDelegate: AnyObject {
    
    func didFetchCurrentUser()
    func didUploadThread(result: Result<TCThread, Error>)
    
}

final class TCThreadCreationViewViewModel {
    
    // MARK: - Private Properties
    
    private var currentUser: TCUser?
    
    // MARK: - Public Methods
    
    public var delegate: TCThreadCreationViewViewModelDelegate?
    
    public var username: String {
        return currentUser?.username ?? ""
    }
    
    public var profilePictureImageUrl: String {
        return currentUser?.profileImageUrl ?? ""
    }
    
    // MARK: - Initialization
    
    init() {}
    
    // MARK: - Public Methods
    
    public func fetchUser() {
        let userId = TCAuthService.shared.userUid ?? ""
        
        TCUserService.shared.fetchUser(withId: userId) { [weak self] result in
            switch result {
            case .success(let model):
                self?.currentUser = model
                self?.delegate?.didFetchCurrentUser()
            case .failure(let error):
                print("Error fetching currentn user: \(error)")
                break
            }
        }
    }
    
    public func uploadThread(
        withCaption caption: String
    ) {
        guard let ownerUid = currentUser?.id else { return }
        let thread = TCThread(
            ownerUid: ownerUid,
            caption: caption,
            timestamp: Timestamp(),
            likes: 0
        )
        TCThreadService.uploadThread(thread) { [weak self] error in
            guard error == nil else {
                self?.delegate?.didUploadThread(result: .failure(error!))
                print("Error uploading thread data: \(error!)")
                return
            }
        
            self?.delegate?.didUploadThread(result: .success(thread))
        }
    }
    
}
