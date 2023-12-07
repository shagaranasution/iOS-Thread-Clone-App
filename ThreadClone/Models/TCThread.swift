//
//  TCThread.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 17/11/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TCThread: Codable {
    
    @DocumentID var threadId: String?
    let ownerUid: String
    let caption: String
    let timestamp: Timestamp
    var likes: Int
    var user: TCUser?
    
}
