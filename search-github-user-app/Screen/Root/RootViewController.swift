//
//  ViewController.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import UIKit

class RootViewController: UIViewController {
    private var presenter: RootInputCollection!
    
    @IBOutlet weak private var userTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch users
        presenter.getUsers()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let imageUrl = URL(string: presenter.users[indexPath.row].avatarUrl)
        
        cell.textLabel?.text = presenter.users[indexPath.row].name
        cell.imageView?.setImage(with: imageUrl)
        
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
}
