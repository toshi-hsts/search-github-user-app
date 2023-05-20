//
//  RootPresenter.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/20.
//

import Foundation

final class RootPresenter {
    enum LoadState {
        case standby
        case loading
        case none
    }
    
    private weak var view: RootOutputCollection!
    private(set) var users: [UserWrapper] = []
    private var loadState: LoadState = .none
    private var page = 1
    private var searchedWord = ""

    init(view: RootOutputCollection) {
        self.view = view
    }
}

// MARK: - RootPresenterInputCollection
extension RootPresenter: RootInputCollection {
    /// セルタップ時の挙動
    func tapTableViewCell(at index: Int) {
        let user = users[index]
        view.moveToDetail(with: user.name)
    }
    
    /// ユーザを取得する
    @MainActor
    func getUsers() {
        Task {
            do {
                let fetchUsers = try await GitHubAPIClient.shared.getUsers(keyword: searchedWord, page: page)
                
                users += fetchUsers?.items ?? []
                loadState = .standby
                view.tableReload()
                view.stopAnimatingIndicator()
                
                if page == 1 {
                    view.setTotalCount(fetchUsers?.totalCount ?? 0)
                }
            } catch let error as APIError {
                loadState = .standby
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
        getUsers()
    }
    
    ///　検索ボタンが押された際の処理
    @MainActor
    func tapSearchButton(with searchWord: String) {
        searchedWord = searchWord
        getFirstPageUsers()
    }
    
    /// 1 page目のユーザを取得
    @MainActor
    func getFirstPageUsers() {
        view.startAnimatingIndicator()
        page = 1
        users = []
        loadState = .loading
        getUsers()
    }
}
