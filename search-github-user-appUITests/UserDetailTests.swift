//
//  UserDetailTests.swift
//  search-github-user-appUITests
//
//  Created by ToshiPro01 on 2023/05/22.
//

import XCTest

final class UserDetailTests: XCTestCase {

    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
        // 検索
        searchUsers()
        // ユーザセルタップ
        tapUserCell()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // 初期画面が表示されていること
    func testInitialScreen() throws {
        let avatarImage = app.images.firstMatch
        let profile = app.staticTexts["profile"]
        let tableView = app.tables.firstMatch
    
        XCTAssertTrue(avatarImage.exists)
        XCTAssertTrue(profile.exists)
        XCTAssertTrue(tableView.exists)
    }

    // Root画面に遷移できること
    func testBackRootScreen() throws {
        let rootScreenTitle = "GitHubユーザ検索くん"
        app.buttons["戻る"].tap()
        XCTAssertTrue(app.navigationBars[rootScreenTitle].exists)
    }
    
    // WebView画面に遷移できること
    func testShowWebViewScreen() throws {
        let firstCell = app.cells.element(boundBy: 0)
        firstCell.tap()
        //　詳細画面表示されているか確認
        let rootScreenTitle = "戻る"
        XCTAssertTrue(app.buttons[rootScreenTitle].exists)
    }

    // 検索
    private func searchUsers() {
        let searchWord = "a"
        let searchBar = app.searchFields.firstMatch

        // 検索
        searchBar.tap()
        searchBar.typeText(searchWord)
        app.buttons["Search"].tap()

        // 通信待ち
        let loadingText = app.otherElements["loadingView"]
        let notExists = NSPredicate(format: "exists == false")

        expectation(for: notExists, evaluatedWith: loadingText, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
    }

    // セルタップ
    private func tapUserCell() {
        let firstCell = app.cells.element(boundBy: 0)
        firstCell.tap()
    }
}
