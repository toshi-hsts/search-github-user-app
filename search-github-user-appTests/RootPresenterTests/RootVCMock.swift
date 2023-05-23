//
//  RootVCMock.swift
//  search-github-user-appTests
//
//  Created by ToshiPro01 on 2023/05/23.
//

import Foundation
@testable import search_github_user_app

class RootVCMock: RootOutputCollection {

    var calledFunctionName = ""

    func moveToDetail(with userName: String) {
        calledFunctionName = #function
    }

    func startAnimatingIndicator() {
    }

    func stopAnimatingIndicator() {
    }

    func showErrorAlert(with message: String) {
    }

    func tableReload() {
    }

    func setTotalCount(_ totalCount: Int) {
    }
}
