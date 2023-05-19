//
//  RootPresenter.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/20.
//

import Foundation

final class RootPresenter {
    private weak var view: RootOutputCollection!
    private(set) var users: [UserWrapper] = []

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
    
    @MainActor
    func getUsers() {
        Task {
            users = await GitHubAPIClient.shared.getUsers()
            view.tableReload()
        }
    }
}
