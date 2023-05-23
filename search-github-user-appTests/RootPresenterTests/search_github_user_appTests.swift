//
//  search_github_user_appTests.swift
//  search-github-user-appTests
//
//  Created by ToshiPro01 on 2023/05/23.
//

import XCTest
@testable import search_github_user_app

final class RootPresenterTests: XCTestCase {
    let rootVCMock = RootVCMock()
    let gitHubAPIClientMock = APIClientMock()
    lazy var rootPresenter = RootPresenter(view: rootVCMock, apiClient: gitHubAPIClientMock)

    /// セルタップ時の挙動
    func testTapTableViewCell() {

        let user = UserWrapper(name: "testUser", avatarUrl: "avatarUrl", userInfoUrl: "userInfoUrl")
        rootPresenter.setUsers(with: [user])
        rootPresenter.tapTableViewCell(at: 0)

        // モック関数が呼ばれていることを確認する
        XCTAssertEqual(rootVCMock.calledFunctionName, "moveToDetail(with:)")
    }
}
