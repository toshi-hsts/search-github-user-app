//
//  WebViewPresenter.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/20.
//

import Foundation

final class WebViewPresenter {
    private weak var view: WebViewOutputCollection!
    var urlString: String = ""
    

    init(view: WebViewOutputCollection, urlString: String) {
        self.view = view
        self.urlString = urlString
    }
}

// MARK: - UserDetailPresenterInputCollection
extension WebViewPresenter: WebViewInputCollection {
}
