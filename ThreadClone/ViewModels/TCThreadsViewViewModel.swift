//
//  TCThreadsViewViewModel.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 17/11/23.
//

import Foundation

protocol TCThreadsViewViewModelDelegate: AnyObject {
    
    func didFetchThreads()
    
}

final class TCThreadsViewViewModel {
    
    // MARK: - Private Properties
    
    private var currentUserId: String?
    
    private(set) var threads: [TCThread] = []
    
    // MARK: - Public Properties
    
    public var delegate: TCThreadsViewViewModelDelegate?
    
    // MARK: - Initialization
    
    init(
        withCurrentUserId currentUserId: String? = nil
    ) {
        self.currentUserId = currentUserId
    }
    
    // MARK: - Public Methods
    
    public func fetchThreads() {
        TCThreadService.fetchThreads { [weak self] result in
            switch result {
            case .success(let threads):
                guard let self = self else { return }
                
                if let currentUserId = self.currentUserId {
                    self.threads = threads.filter({ thread in
                        thread.ownerUid == currentUserId
                    })
                } else {
                    self.threads = threads
                }
               
                for (index, thread) in self.threads.enumerated() {
                    let userId = thread.ownerUid
                    
                    TCUserService.shared.fetchUser(
                        withId: userId
                    ) { result in
                        switch result {
                        case .success(let user):
                            
                            self.threads[index].user = user
                            if index == self.threads.count - 1 {
                                self.delegate?.didFetchThreads()
                            }
                        case .failure(let error):
                            print("Error fetching user: \(error)")
                            break
                        }
                    }
                }
            
                self.delegate?.didFetchThreads()
            case .failure(let error):
                print("Error fetching threads: \(error)")
                break
            }
        }
    }
    
}
