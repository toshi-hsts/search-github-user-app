//
//  DetailPresenter.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/20.
//

import Foundation

final class UserDetailPresenter {
    private weak var view: UserDetailOutputCollection!
    private(set) var userName: String = ""
    private(set) var user: User?
    private(set) var repositories: [Repository] = []

    init(view: UserDetailOutputCollection, userName: String) {
        self.view = view
        self.userName = userName
    }
    
    private func fetchUser() async {
        user = await GitHubAPIClient.shared.getUser(with: userName)
    }
    
    private func fetchNotForkedRepositories() async {
        let fetchedRepositories = await GitHubAPIClient.shared.getRepositories(with: userName)
        repositories = fetchedRepositories.filter { $0.isFork == false }
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
            async let fetchUser: () =  fetchUser()
            async let fetchNotForkedRepositories: () = fetchNotForkedRepositories()
            let _ = await (fetchUser, fetchNotForkedRepositories)
            
            view.stopAnimatingIndicator()
            view.loadUserInfo()
        }
    }
}
