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
    private weak var githubAPIClient: GitHubAPIClientCollection!
    private(set) var userName: String = ""
    private(set) var user: User?
    private(set) var repositories: [Repository] = []
    private var loadState: LoadState = .none
    private var page = 1
    private var lastPage = 1

    init(view: UserDetailOutputCollection,
         apiClient: GitHubAPIClientCollection,
         userName: String) {
        self.view = view
        self.githubAPIClient = apiClient
        self.userName = userName
    }

    private func fetchUser() async throws {
        user = try await githubAPIClient.getUser(with: userName)
    }

    private func fetchNotForkedRepositories() async throws {
        let fetchedWrapperRepositories = try await githubAPIClient.getRepositories(with: userName, page: page)

        if let lastPage = fetchedWrapperRepositories.lastPage {
            self.lastPage = lastPage
        }

        repositories += fetchedWrapperRepositories.repositories.filter { $0.isFork == false }
        loadState = .standby

        if repositories.isEmpty {
            handleNoRepository()
        }
    }
}

// MARK: - UserDetailPresenterInputCollection
extension UserDetailPresenter: UserDetailInputCollection {
    /// セルタップ時の挙動
    func tapTableViewCell(at index: Int) {
        let repository = repositories[index]
        view.moveToDetail(with: repository.htmlUrl)
    }
    /// リポジトリ0件のとき
    func handleNoRepository() {
        view.showNoResultView()
    }
    /// ユーザ詳細情報取得
    @MainActor
    func getUser() {
        Task {
            do {
                async let fetchUser: () =  fetchUser()
                async let fetchNotForkedRepositories: () = fetchNotForkedRepositories()
                _ = try await (fetchUser, fetchNotForkedRepositories)

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
        guard lastPage != page else { return }

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
