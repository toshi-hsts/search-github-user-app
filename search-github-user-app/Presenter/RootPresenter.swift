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
            let fetchUsers = await GitHubAPIClient.shared.getUsers(page: page)
            users += fetchUsers
            loadState = .standby
            view.tableReload()
            view.stopAnimatingIndicator()
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
}
