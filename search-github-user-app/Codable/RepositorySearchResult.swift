//
//  RepositorySearchResult.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/19.
//

import Foundation

struct RepositorySearchResult: Decodable {
    let repositories: [Repository]

    enum CodingKeys: String, CodingKey {
        case repositories = ""
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        repositories = try container.decode([Repository].self)
    }
}
