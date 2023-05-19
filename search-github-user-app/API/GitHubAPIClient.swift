//
//  GitHubAPIClient.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import Foundation

class GitHubAPIClient {
    func getUsers() async throws -> [UserWrapper] {
        // TODO: swiftという文言でクエリしてる部分を検索機能で取得した値に置き換える
        let urlString = "https://api.github.com/search/users?q=swift"
        var users: [UserWrapper] = []
        
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
                let searchResult  = try JSONDecoder().decode(UserSearchResult.self, from: data)
                users = searchResult.items
            case 400... :
                fatalError()
            default:
                fatalError()
                break
            }
        } catch {
            fatalError()
        }
        
        return users
    }
    
    func getUser(with name: String) async throws -> User? {
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
                print("koko")
                let searchResult  = try JSONDecoder().decode(User.self, from: data)
                print(searchResult)
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
    
    func getRepositories(with userName: String) async throws -> [Repository] {
        let urlString = "https://api.github.com/users/\(userName)/repos"
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
                print("koko")
                let searchResult  = try JSONDecoder().decode(RepositorySearchResult.self, from: data)
                print(searchResult)
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
