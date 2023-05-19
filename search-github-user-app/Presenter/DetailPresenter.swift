//
//  DetailPresenter.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/20.
//

import Foundation

final class UserDetailPresenter {
    private weak var view: UserDetailOutputCollection!
    

    init(view: UserDetailOutputCollection, userName: String) {
        self.view = view
    }
}

// MARK: - UserDetailPresenterInputCollection
extension UserDetailPresenter: UserDetailInputCollection {
}
