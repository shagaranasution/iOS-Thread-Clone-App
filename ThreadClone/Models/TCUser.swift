//
//  TCUser.swift
//  ThreadClone
//
//  Created by Shagara F Nasution on 14/11/23.
//

import Foundation

struct TCUser: Identifiable, Codable {
    let id: String
    let fullName: String
    let email: String
    let username: String
    var profileImageUrl: String?
    var bio: String?
    var link: String?
}
