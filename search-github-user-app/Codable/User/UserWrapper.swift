//
//  UserWrapper.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import Foundation

struct UserWrapper: Decodable {
    let name: String
    let avatarUrl: String
    let userInfoUrl: String

    enum CodingKeys: String, CodingKey {
        case name = "login"
        case avatarUrl = "avatar_url"
        case userInfoUrl = "url"
    }
}
