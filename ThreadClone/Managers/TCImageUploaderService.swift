//
//  TCImageUploaderService.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 06/12/23.
//

import UIKit
import FirebaseCore
import FirebaseStorage

struct TCImageUploaderService {
    
    public static let shared = TCImageUploaderService()
    
    private init() {}
    
    public func uploadImage(
        _ image: UIImage,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let imageData = image.jpegData(compressionQuality: 0.25) else { return }
        let fileName = NSUUID().uuidString
        let storageRef = Storage.storage().reference(withPath: "/profile_images/\(fileName).jpg")
        
        storageRef.putData(imageData) { metadata, error in
            if let error = error {
                print("Error uploading image to storage: \(error)")
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { result in
                switch result {
                case .success(let url):
                    completion(.success(url.absoluteString))
                case .failure(let error):
                    print("Error download image url from storage: \(error)")
                    completion(.failure(error))
                }
            }
        }
    }
    
}
