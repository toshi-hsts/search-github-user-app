//
//  Repository.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/19.
//

import Foundation

struct Repository: Decodable {
    let name: String
    let initialLanguage: String? // nilが返却される可能性があるためオプショナルとする(cf. https://docs.github.com/ja/rest/search)
    let stargazersCount: Int
    let description: String? // nilが返却される可能性があるためオプショナルとする(cf. https://docs.github.com/ja/rest/search)
    let htmlUrl: String
    let isFork: Bool
    
    // initialLanguageがnilのときは"unknown"とする
    var language: String {
        initialLanguage == nil ? "unknown language" : initialLanguage!
    }

    enum CodingKeys: String, CodingKey {
        case name
        case initialLanguage = "language"
        case stargazersCount = "stargazers_count"
        case description
        case htmlUrl = "html_url"
        case isFork = "fork"
    }
}
