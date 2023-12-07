//
//  TCAuthService.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 12/11/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

final class TCAuthService {
    
    // MARK: Static Properties
    
    public static let shared = TCAuthService()
    
    // MARK: - Private Properties
    
    public var userUid: String? {
        UserDefaults.standard.string(forKey: "userUid")
    }
    
    private var userEmail: String? {
        UserDefaults.standard.string(forKey: "userEmail")
    }
    
    private var userDisplayName: String? {
        UserDefaults.standard.string(forKey: "userUid")
    }
    
    // MARK: - Public Properties
    
    public var isSignedIn: Bool {
        return userUid != nil
    }
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Private Methods
    
    private func cacheSession(fromData data: AuthDataResult) {
        UserDefaults.standard.set(data.user.uid, forKey: "userUid")
        UserDefaults.standard.set(data.user.email, forKey: "userEmail")
        UserDefaults.standard.set(data.user.displayName, forKey: "userDisplayName")
    }
    
    private func uploadUserData(
        withEmail email: String,
        fullName: String,
        username: String,
        id: String,
        completion: @escaping ((Error?) -> Void)
    ) {
        let user = TCUser(id: id, fullName: fullName, email: email, username: username)
        do {
            let userData = try Firestore.Encoder().encode(user)
            Firestore
                .firestore()
                .collection("users")
                .document(id)
                .setData(
                    userData,
                    completion: completion
                )
        } catch {
            print("Error encoding data: \(error)")
        }
       
    }
    
    // MARK: - Public Methods
    
    public func signIn(
        withEmail email: String,
        password: String,
        completion: ((Result<AuthDataResult, Error>) -> Void)?
    ) {
        Auth.auth().signIn(
            withEmail: email,
            password: password
        ) { [weak self] result, error in
            guard let result = result, error == nil else {
                print("Error singing in: \(error!.localizedDescription)")
                completion?(.failure(error!))
                
                return
            }
            self?.cacheSession(fromData: result)
            completion?(.success(result))
        }
    }
    
    public func signUp(
        withEmail email: String,
        password: String,
        fullName: String,
        username: String,
        completion: ((Result<AuthDataResult, Error>) -> Void)?
    ) {
        Auth.auth().createUser(
            withEmail: email,
            password: password
        ) { [weak self] result, error in
            guard let result = result, error == nil else {
                completion?(.failure(error!))
                
                return
            }
            
            self?.cacheSession(fromData: result)
            self?.uploadUserData(
                withEmail: email,
                fullName: fullName,
                username: username,
                id: result.user.uid,
                completion: { error in
                    guard let error = error else { return }
                    completion?(.failure(error))
                }
            )
            
            completion?(.success(result))
        }
    }
    
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(nil, forKey: "userUid")
            UserDefaults.standard.set(nil, forKey: "userEmail")
            UserDefaults.standard.set(nil, forKey: "userDisplayName")
            completion(true)
        } catch {
            print("Error signing out: \(error.localizedDescription)")
            completion(false)
        }
    }
    
}
