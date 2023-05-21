//
//  GitHubAPIClient.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import Foundation

class GitHubAPIClient {
    
    public static let shared = GitHubAPIClient()

    let apiVersion = "2022-11-28"
    let accept = "application/vnd.github+json"
    let authorization = Env.accessToken.isEmpty ? "" : "Bearer \(Env.accessToken)"
    
    
    
    func getUsers(keyword: String, page: Int) async throws -> UserSearchResult? {
        let urlString = "https://api.github.com/search/users?q=\(keyword)&page=\(page)"
        var searchResult: UserSearchResult?
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidSearchWord
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // ヘッダ情報付与
        request.allHTTPHeaderFields = [
            "X-GitHub-Api-Version" : apiVersion,
            "Accept" : accept,
            "Authorization" : authorization
        ]
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: request)
            guard let httpStatus = urlResponse as? HTTPURLResponse else {
                throw APIError.notStatusCode
            }
            
            switch httpStatus.statusCode {
            case 200 ..< 400:
                do {
                    searchResult  = try JSONDecoder().decode(UserSearchResult.self, from: data)
                } catch let error {
                    throw APIError.decodeFailure(statusCode: httpStatus.statusCode, catchErrorText: error.localizedDescription)
                }
            case 400 ..< 500:
                throw APIError.clientFailure
            default:
                throw APIError.networkFailure
            }
        } catch let error {
            throw APIError.noResponseData(catchErrorText: error.localizedDescription)
        }
        
        return searchResult
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
            "X-GitHub-Api-Version" : apiVersion,
            "Accept" : accept,
            "Authorization" : authorization
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
                    throw APIError.decodeFailure(statusCode: httpStatus.statusCode, catchErrorText: error.localizedDescription)
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
    
    func getRepositories(with userName: String, page: Int) async throws -> [Repository] {
        let urlString = "https://api.github.com/users/\(userName)/repos?page=\(page)"
        var repositories: [Repository] = []
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidSearchWord
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // ヘッダ情報付与
        request.allHTTPHeaderFields = [
            "X-GitHub-Api-Version" : apiVersion,
            "Accept" : accept,
            "Authorization" : authorization
        ]
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: request)
            
            guard let httpStatus = urlResponse as? HTTPURLResponse else {
                throw APIError.notStatusCode
            }
            
            switch httpStatus.statusCode {
            case 200 ..< 400:
                do {
                    let searchResult  = try JSONDecoder().decode(RepositorySearchResult.self, from: data)
                    repositories = searchResult.repositories
                } catch let error {
                    throw APIError.decodeFailure(statusCode: httpStatus.statusCode, catchErrorText: error.localizedDescription)
                }
            case 400 ..< 500 :
                throw APIError.clientFailure
            default:
                throw APIError.networkFailure
            }
        } catch let error {
            throw APIError.noResponseData(catchErrorText: error.localizedDescription)
        }
        
        return repositories
    }
}
