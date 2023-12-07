//
//  TCUserService.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 14/11/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class TCUserService {
    
    // MARK: - Static
    
    public static let shared = TCUserService()
    
    // MARK: - Private Properties
    
    private var currentUserId: String {
        return TCAuthService.shared.userUid ?? ""
    }
    
    private var db: Firestore {
        return Firestore.firestore()
    }
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Mehtods
    
    public func fetchUser(
        withId id: String,
        completion: @escaping ((Result<TCUser, Error>) -> Void)
    ) {
        db.collection("users")
            .document(id)
            .getDocument { snapshot, error in
                guard let snapshot = snapshot,
                      error == nil
                else {
                    completion(.failure(error!))
                    return
                }
                
                do {
                    let user = try snapshot.data(as: TCUser.self)
                    completion(.success(user))
                } catch {
                    completion(.failure(error))
                }
            }
    }
    
    public func fetchUsers(
        completion: @escaping ((Result<[TCUser], Error>) -> Void)
    ) {
        db.collection("users")
            .getDocuments { snapshots, error in
                guard let snapshots = snapshots,
                      error == nil
                else {
                    completion(.failure(error!))
                    return
                }
            
                let users = snapshots.documents.compactMap { snapshot in
                    try? snapshot.data(as: TCUser.self)
                }.filter{ [weak self] user in
                    user.id != self?.currentUserId
                }
                
                completion(.success(users))
            }
    }
    
    public func updateUserData(
        withFullName fullName: String,
        bio: String,
        link: String,
        imageUrlString: String,
        completion: @escaping ((Bool) -> Void)
    ) {
        guard let userId = TCAuthService.shared.userUid else { return }
        
        let fields: [AnyHashable:Any] = [
            "fullName": fullName,
            "bio": bio,
            "link": link,
            "profileImageUrl": imageUrlString
        ]
        
        db.collection("users")
            .document(userId)
            .updateData(fields) { error in
                if let error = error {
                    completion(false)
                    print("Error updating data: \(error)")
                    return
                }
                
                completion(true)
            }
    }
    
}
