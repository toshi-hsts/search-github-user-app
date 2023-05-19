//
//  User.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import Foundation

struct User: Decodable {
    let fullName: String? // nilが返却される可能性があるためオプショナルとする
    let name: String
    let bio: String? // nilが返却される可能性があるためオプショナルとする
    let followers: Int
    let following: Int
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
