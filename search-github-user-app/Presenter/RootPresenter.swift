//
//  RootPresenter.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/20.
//

import Foundation

final class RootPresenter {
    private weak var view: RootOutputCollection!

    init(view: RootOutputCollection) {
        self.view = view
    }
}

// MARK: - RootPresenterInputCollection
extension RootPresenter: RootInputCollection {
}
