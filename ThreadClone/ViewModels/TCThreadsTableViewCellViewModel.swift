//
//  TCThreadsTableViewCellViewModel.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 19/10/23.
//

import Foundation

final class TCThreadsTableViewCellViewModel {
    
    // MARK: - Private Properties
    
    private let thread: TCThread
    
    // MARK: - Public Properties
    
    public var username: String {
        return thread.user?.username ?? "username.unknown"
    }
    
    public var profilePictureImageUrl: String {
        return thread.user?.profileImageUrl ?? ""
    }
    
    public var threadCaption: String {
        return thread.caption
    }
    
    public var threadCreatedDateString: String {
        return TCDate.formatTimestamp(from: thread.timestamp)
    }
    
    // MARK: - Initialization
    
    init(thread: TCThread) {
        self.thread = thread
    }
    
}
