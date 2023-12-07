//
//  TCAuthViewViewModel.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 13/11/23.
//

import Foundation
import FirebaseAuth

final class TCAuthViewViewModel {
    
    public func signIn(
        withEmail email: String,
        password: String,
        completion: ((Result<AuthDataResult, Error>) -> Void)? = nil
    ) {
        TCAuthService.shared.signIn(
            withEmail: email,
            password: password,
            completion: completion
        )
    }
    
}
