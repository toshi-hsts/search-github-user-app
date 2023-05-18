//
//  User.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import Foundation

struct User: Decodable {
    let login: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
