//
//  UserSearchResult.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import Foundation

struct UserSearchResult: Decodable {
    let totalCount: Int
    let items: [User]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}
