//
//  GitHubAPIClient.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import Foundation

class GitHubAPIClient {
    
    public static let shared = GitHubAPIClient()
    
    func getUsers(keyword: String, page: Int) async -> UserSearchResult? {
        let urlString = "https://api.github.com/search/users?q=\(keyword)&page=\(page)"
        var searchResult: UserSearchResult?
        
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        
        let authorization = Env.accessToken.isEmpty ? "" : "Bearer \(Env.accessToken)"
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // ヘッダ情報付与
        request.allHTTPHeaderFields = [
            "X-GitHub-Api-Version" : "2022-11-28",
            "Accept" : "application/vnd.github+json",
            "Authorization" : authorization
        ]
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: request)
            
            guard let httpStatus = urlResponse as? HTTPURLResponse else {
                fatalError()
            }
            
            switch httpStatus.statusCode {
            case 200 ..< 400:
                searchResult  = try JSONDecoder().decode(UserSearchResult.self, from: data)
            case 400... :
                fatalError()
            default:
                fatalError()
                break
            }
        } catch {
            fatalError()
        }
        
        return searchResult
    }
    
    func getUser(with name: String) async -> User? {
        let urlString = "https://api.github.com/users/\(name)"
        var user: User?
        
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        
        let authorization = Env.accessToken.isEmpty ? "" : "Bearer \(Env.accessToken)"
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // ヘッダ情報付与
        request.allHTTPHeaderFields = [
            "X-GitHub-Api-Version" : "2022-11-28",
            "Accept" : "application/vnd.github+json",
            "Authorization" : authorization
        ]
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: request)
            
            guard let httpStatus = urlResponse as? HTTPURLResponse else {
                fatalError()
            }
            
            switch httpStatus.statusCode {
            case 200 ..< 400:
                let searchResult  = try JSONDecoder().decode(User.self, from: data)
                user = searchResult
            case 400... :
                fatalError()
            default:
                fatalError()
                break
            }
        } catch {
            fatalError()
        }
        
        return user
    }
    
    func getRepositories(with userName: String, page: Int) async -> [Repository] {
        let urlString = "https://api.github.com/users/\(userName)/repos?page=\(page)"
        var repositories: [Repository] = []
        
        guard let url = URL(string: urlString) else {
            fatalError()
        }
        
        let authorization = Env.accessToken.isEmpty ? "" : "Bearer \(Env.accessToken)"
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // ヘッダ情報付与
        request.allHTTPHeaderFields = [
            "X-GitHub-Api-Version" : "2022-11-28",
            "Accept" : "application/vnd.github+json",
            "Authorization" : authorization
        ]
        
        do {
            let (data, urlResponse) = try await URLSession.shared.data(for: request)
            
            guard let httpStatus = urlResponse as? HTTPURLResponse else {
                fatalError()
            }
            
            switch httpStatus.statusCode {
            case 200 ..< 400:
                let searchResult  = try JSONDecoder().decode(RepositorySearchResult.self, from: data)
                repositories = searchResult.repositories
            case 400... :
                fatalError()
            default:
                fatalError()
                break
            }
        } catch {
            fatalError()
        }
        
        return repositories
    }
}
