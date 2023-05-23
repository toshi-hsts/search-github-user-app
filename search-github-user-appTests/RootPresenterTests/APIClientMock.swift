//
//  APIClientMock.swift
//  search-github-user-appTests
//
//  Created by ToshiPro01 on 2023/05/23.
//

import Foundation
@testable import search_github_user_app

class APIClientMock: GitHubAPIClientCollection {
    var calledFunctionName = ""

    func getUsers(keyword: String, page: Int) async throws -> UserSearchResultWrapper {
        calledFunctionName = #function

        let userWrapper = UserWrapper(name: "user", avatarUrl: "avatarUrl", userInfoUrl: "userInfoUrl")
        let userSearchResult = UserSearchResult(totalCount: 100, items: [userWrapper])

        let userSearchResultWrapper = UserSearchResultWrapper(userSearchResult: userSearchResult, lastPage: 10)

        return userSearchResultWrapper
    }

    func getUser(with name: String) async throws -> User? {
        calledFunctionName = #function
        return nil
    }

    func getRepositories(with userName: String, page: Int) async throws -> RepositoryWrapper {
        calledFunctionName = #function
        let repository = Repository(name: "name",
                                    initialLanguage: "swift",
                                    stargazersCount: 100,
                                    description: "description",
                                    htmlUrl: "url",
                                    isFork: false)
        let repositoryWrapper = RepositoryWrapper(repositories: [repository], lastPage: 10)

        return  repositoryWrapper
    }
}
