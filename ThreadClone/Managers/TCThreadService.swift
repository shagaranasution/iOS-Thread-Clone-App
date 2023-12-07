//
//  TCThreadService.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 17/11/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TCThreadService {
    
    private var db = Firestore.firestore()
    
    static func fetchThreads(
        completion: @escaping (Result<[TCThread], Error>) -> Void
    ) {
        Firestore
            .firestore()
            .collection("threads")
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                guard let snapshot = snapshot,
                      error == nil
                else {
                    completion(.failure(error!))
                    return
                }
                
                let threads = snapshot.documents.compactMap { document in
                    return try? document.data(as: TCThread.self)
                }
                
                completion(.success(threads))
            }
    }
    
    static func uploadThread(
        _ thread: TCThread,
        completion: @escaping ((Error?) -> Void)
    ) {
        do {
            let threadData = try Firestore.Encoder().encode(thread)
            Firestore
                .firestore()
                .collection("threads")
                .addDocument(data: threadData, completion: completion)
        } catch {
            completion(error)
        }
    }
    
}
