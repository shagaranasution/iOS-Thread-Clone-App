//
//  TCRegistrationViewViewModel.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 12/11/23.
//

import Foundation
import FirebaseAuth

final class TCRegistrationViewViewModel {
    
    public func createUser(
        email: String,
        password: String,
        fullName: String,
        username: String,
        completion: ((Result<AuthDataResult, Error>) -> Void)? = nil
    ) {
        TCAuthService.shared.signUp(
            withEmail: email,
            password: password,
            fullName: fullName,
            username: username,
            completion: completion
        )
    }
    
}
