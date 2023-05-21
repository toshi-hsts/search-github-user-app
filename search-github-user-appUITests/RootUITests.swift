//
//  RootUITests.swift
//  search-github-user-appUITests
//
//  Created by ToshiPro01 on 2023/05/22.
//

import XCTest

final class RootUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // 初期画面テスト
    func testInitialScreen() throws {
        XCTContext.runActivity(named: "SearchBarが表示されていること") { _ in
            let searchBar = app.searchFields.firstMatch
            XCTAssertTrue(searchBar.exists)
        }

        XCTContext.runActivity(named: "SearchBarに初期文字列が入力されていること") { _ in
            let searchBar = app.searchFields.firstMatch
            XCTAssertEqual(searchBar.value as? String, "検索したいユーザを入力してね")
        }

        XCTContext.runActivity(named: "TableViewが表示されていること") { _ in
            let tableView = app.tables.firstMatch
            XCTAssertTrue(tableView.exists)
        }

        XCTContext.runActivity(named: "TableViewにセルが表示されていないこと") { _ in
            let firstCell = app.cells.element(boundBy: 0)
            XCTAssertFalse(firstCell.exists)
        }

        XCTContext.runActivity(named: "initialImageViewが表示されていること") { _ in
            XCTAssertTrue(app.images["initialImageView"].exists)
        }
    }

    // レポジトリ検索ができること
    func testSearchRepository() throws {
        // 検索
        searchUsers()
        // セルが存在するか確認
        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists)
    }

    // 検索キーワードがないときは検索ができないこと
    func testNotSearchRepository() throws {
        let searchBar = app.searchFields.firstMatch
        // 検索
        searchBar.tap()
        app.buttons["Search"].tap()

        XCTAssertFalse(app.otherElements["loadingView"].exists)
    }

    // Detail画面に遷移できること
    func testShowDetail() throws {
        // 検索
        searchUsers()
        // セルタップ
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
}
