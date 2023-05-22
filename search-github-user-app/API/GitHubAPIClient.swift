//
//  GitHubAPIClient.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import Foundation

final class GitHubAPIClient: GitHubAPIClientCollection {

    public static let shared = GitHubAPIClient()

    private let apiVersion = "2022-11-28"
    private let accept = "application/vnd.github+json"
    private let authorization = Env.accessToken.isEmpty ? "" : "Bearer \(Env.accessToken)"

    func getUsers(keyword: String, page: Int) async throws -> UserSearchResultWrapper {
        let urlString = "https://api.github.com/search/users?q=\(keyword)&page=\(page)"
        var searchResult: UserSearchResult?
        var lastPage: Int?

        guard let url = URL(string: urlString) else {
            throw APIError.invalidSearchWord
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // ヘッダ情報付与
        request.allHTTPHeaderFields = [
            "X-GitHub-Api-Version": apiVersion,
            "Accept": accept,
            "Authorization": authorization
        ]

        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: request)
            guard let httpStatus = urlResponse as? HTTPURLResponse else {
                throw APIError.notStatusCode
            }

            let res = urlResponse as? HTTPURLResponse
            let headers = res?.allHeaderFields
            lastPage = getLastPage(from: headers?["Link"] as? String)

            switch httpStatus.statusCode {
            case 200 ..< 400:
                do {
                    searchResult  = try JSONDecoder().decode(UserSearchResult.self, from: data)
                } catch let error {
                    throw APIError.decodeFailure(statusCode: httpStatus.statusCode,
                                                 catchErrorText: error.localizedDescription)
                }
            case 400 ..< 500:
                throw APIError.clientFailure
            default:
                throw APIError.networkFailure
            }
        } catch let error {
            throw APIError.noResponseData(catchErrorText: error.localizedDescription)
        }

        let userSearchResultWrapper = UserSearchResultWrapper(userSearchResult: searchResult, lastPage: lastPage)

        return userSearchResultWrapper
    }

    func getUser(with name: String) async throws -> User? {
        let urlString = "https://api.github.com/users/\(name)"
        var user: User?

        guard let url = URL(string: urlString) else {
            throw APIError.invalidSearchWord
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // ヘッダ情報付与
        request.allHTTPHeaderFields = [
            "X-GitHub-Api-Version": apiVersion,
            "Accept": accept,
            "Authorization": authorization
        ]

        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: request)

            guard let httpStatus = urlResponse as? HTTPURLResponse else {
                throw APIError.notStatusCode
            }

            switch httpStatus.statusCode {
            case 200 ..< 400:
                do {
                    let searchResult  = try JSONDecoder().decode(User.self, from: data)
                    user = searchResult
                } catch let error {
                    throw APIError.decodeFailure(statusCode: httpStatus.statusCode,
                                                 catchErrorText: error.localizedDescription)
                }
            case 400 ..< 500:
                throw APIError.clientFailure
            default:
                throw APIError.networkFailure
            }
        } catch let error {
            throw APIError.noResponseData(catchErrorText: error.localizedDescription)
        }

        return user
    }

    func getRepositories(with userName: String, page: Int) async throws -> RepositoryWrapper {
        let urlString = "https://api.github.com/users/\(userName)/repos?page=\(page)"
        var repositories: [Repository] = []
        var lastPage: Int?

        guard let url = URL(string: urlString) else {
            throw APIError.invalidSearchWord
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // ヘッダ情報付与
        request.allHTTPHeaderFields = [
            "X-GitHub-Api-Version": apiVersion,
            "Accept": accept,
            "Authorization": authorization
        ]

        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: request)

            guard let httpStatus = urlResponse as? HTTPURLResponse else {
                throw APIError.notStatusCode
            }

            let res = urlResponse as? HTTPURLResponse
            let headers = res?.allHeaderFields
            lastPage = getLastPage(from: headers?["Link"] as? String)

            switch httpStatus.statusCode {
            case 200 ..< 400:
                do {
                    let searchResult  = try JSONDecoder().decode(RepositorySearchResult.self, from: data)
                    repositories = searchResult.repositories
                } catch let error {
                    throw APIError.decodeFailure(statusCode: httpStatus.statusCode,
                                                 catchErrorText: error.localizedDescription)
                }
            case 400 ..< 500 :
                throw APIError.clientFailure
            default:
                throw APIError.networkFailure
            }
        } catch let error {
            throw APIError.noResponseData(catchErrorText: error.localizedDescription)
        }

        let repositoryWrapper = RepositoryWrapper(repositories: repositories, lastPage: lastPage)
        return repositoryWrapper
    }

    /// ページネーション情報から最後のページを取得
    private func getLastPage(from linkHeader: String?) -> Int? {
        guard let linkHeader = linkHeader else { return nil }

        var lastPageNumber: Int?

        let links = linkHeader.components(separatedBy: ",")
        for link in links {
            if link.contains("rel=\"last\"") {
                let regexPattern = "page=(\\d+)"
                if let range = link.range(of: regexPattern, options: .regularExpression) {
                    let lastPageString = link[range].replacingOccurrences(of: "page=", with: "")
                    lastPageNumber = Int(lastPageString)

                }
            }
        }

        return lastPageNumber
    }
}
