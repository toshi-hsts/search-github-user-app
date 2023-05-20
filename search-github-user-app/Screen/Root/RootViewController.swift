//
//  ViewController.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import UIKit

class RootViewController: UIViewController {
    private var presenter: RootInputCollection!
    private let cell = "userCell"
    
    @IBOutlet weak private var userTableView: UITableView!
    @IBOutlet weak private var loadingView: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // start indicator
        startAnimatingIndicator()
        // fetch users
        presenter.getUsers()
        // setup xib
        userTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: cell)
    }

    func inject(_ presenter: RootInputCollection) {
        self.presenter = presenter
    }
}

// MARK: - UITableViewDataSource
extension RootViewController: UITableViewDataSource {
    // セル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.users.count
    }
    
    // セル設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath) as! UserTableViewCell
        let name = presenter.users[indexPath.row].name
        let imageUrlString = presenter.users[indexPath.row].avatarUrl
        
        cell.setup(name: name, iconUrl: imageUrlString)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RootViewController: UITableViewDelegate {
    // セルタップ時に呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.tapTableViewCell(at: indexPath.row)
    }
}

// MARK: - RootOutputCollection
extension RootViewController: RootOutputCollection {
    /// 詳細画面に移動する
    func moveToDetail(with userName: String) {
        Router.shared.showDetail(with: userName) { detailVC in
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    /// テーブル更新
    func tableReload() {
        userTableView.reloadData()
    }
    
    /// インジケーターを開始する
    func startAnimatingIndicator() {
        loadingView.startAnimatingIndicator()
        loadingView.isHidden = false
        view.isUserInteractionEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    /// インジケータを停止する
    func stopAnimatingIndicator() {
        loadingView.stopAnimatingIndicator()
        loadingView.isHidden = true
        view.isUserInteractionEnabled = true
        navigationController?.navigationBar.isUserInteractionEnabled = true
    }
}
