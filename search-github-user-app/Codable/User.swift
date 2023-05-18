//
//  User.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import Foundation

struct User: Decodable {
    let fullName: String
    let name: String
    let bio: String
    let followers: String
    let following: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case fullName = "name"
        case name = "login"
        case avatarUrl = "avatar_url"
        case followers
        case following
        case bio
    }
}
