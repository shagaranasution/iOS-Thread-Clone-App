//
//  TCEditCurrentProfileViewViewModel.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 06/12/23.
//

import Foundation
import UIKit

final class TCEditCurrentProfileViewViewModel {
    
    private var user: TCUser
    
    public var fullName: String {
        return user.fullName
    }
    
    public var bio: String? {
        return user.bio
    }
    
    public var link: String? {
        return user.link
    }
    
    public var profileImageUrl: String? {
        return user.profileImageUrl
    }
    
    init(user: TCUser) {
        self.user = user
    }
    
    public func updateUserData(
        withFullName fullName: String,
        bio: String?,
        link: String?,
        image: UIImage?,
        completion: @escaping ((Bool) -> Void)
    ) {
        var imageUrlString = ""
        let dispatchGroup = DispatchGroup()
        
        if let image = image {
            dispatchGroup.enter()
            TCImageUploaderService.shared.uploadImage(
                image
            ) { result in
                dispatchGroup.leave()
                switch result {
                case .success(let urlString):
                    imageUrlString = urlString
                case .failure:
                    completion(false)
                }
            }
        }
        
        dispatchGroup.notify(queue: .global()) {
            TCUserService.shared.updateUserData(
                withFullName: fullName,
                bio: bio ?? "",
                link: link ?? "",
                imageUrlString: imageUrlString
            ) { isSuccess in
                completion(isSuccess)
            }
        }
       
        
    }
    
}
