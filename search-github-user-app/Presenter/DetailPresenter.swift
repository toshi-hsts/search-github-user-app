//
//  DetailPresenter.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/20.
//

import Foundation

final class UserDetailPresenter {
    enum LoadState {
        case standby
        case loading
        case none
    }
    
    private weak var view: UserDetailOutputCollection!
    private(set) var userName: String = ""
    private(set) var user: User?
    private(set) var repositories: [Repository] = []
    private var loadState: LoadState = .none
    private var page = 1

    init(view: UserDetailOutputCollection, userName: String) {
        self.view = view
        self.userName = userName
    }
    
    private func fetchUser() async throws {
        user = try await GitHubAPIClient.shared.getUser(with: userName)
    }
    
    private func fetchNotForkedRepositories() async throws {
        let fetchedRepositories = try await GitHubAPIClient.shared.getRepositories(with: userName, page: page)
        repositories += fetchedRepositories.filter { $0.isFork == false }
        loadState = .standby
    }
}

// MARK: - UserDetailPresenterInputCollection
extension UserDetailPresenter: UserDetailInputCollection {
    /// セルタップ時の挙動
    func tapTableViewCell(at index: Int) {
        let repository = repositories[index]
        view.moveToDetail(with: repository.htmlUrl)
    }
    
    /// ユーザ詳細情報取得
    @MainActor
    func getUser() {
        Task {
            do {
                async let fetchUser: () =  fetchUser()
                async let fetchNotForkedRepositories: () = fetchNotForkedRepositories()
                let _ = try await (fetchUser, fetchNotForkedRepositories)
                
                view.stopAnimatingIndicator()
                view.loadUserInfo()
            } catch let error as APIError {
                print("error: \(error.description)")
                view.stopAnimatingIndicator()
                view.showErrorAlert(with: error.alertMessage)
            }
        }
    }
    
    /// TableViewが下部に近づいた際の処理
    @MainActor
    func approachTableViewBottom() {
        guard loadState == .standby else { return }

        view.startAnimatingIndicator()
        loadState = .loading
        page += 1
        
        Task {
            do {
                try await fetchNotForkedRepositories()
                
                view.stopAnimatingIndicator()
                view.loadUserInfo()
            } catch let error as APIError {
                print("error: \(error.description)")
                view.stopAnimatingIndicator()
                view.showErrorAlert(with: error.alertMessage)
            }
        }
    }
}
