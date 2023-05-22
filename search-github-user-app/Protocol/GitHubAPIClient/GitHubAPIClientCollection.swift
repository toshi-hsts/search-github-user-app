//
//  GitHubAPIClientCollection.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/22.
//

import Foundation

protocol GitHubAPIClientCollection: AnyObject {
    func getUsers(keyword: String, page: Int) async throws -> UserSearchResultWrapper
    func getUser(with name: String) async throws -> User?
    func getRepositories(with userName: String, page: Int) async throws -> RepositoryWrapper
}
