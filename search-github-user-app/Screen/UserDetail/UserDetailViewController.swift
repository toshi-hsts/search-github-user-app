//
//  UserDetailViewController.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import UIKit

class UserDetailViewController: UIViewController {
    private var presenter: UserDetailInputCollection!
    
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var profileLabel: UILabel!
    @IBOutlet weak private var repositoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getUser()
    }
    
    func inject(presenter: UserDetailInputCollection) {
        self.presenter = presenter
    }
}

// MARK: - UITableViewDataSource
extension UserDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        let repo = presenter.repositories[indexPath.row]
        
        cell.textLabel?.text = "\(repo.name) / 言語：\(repo.language) / ⭐️\(repo.stargazersCount)"
        cell.detailTextLabel?.text = presenter.repositories[indexPath.row].description
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension UserDetailViewController: UITableViewDelegate {
    // セルタップ時に呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.tapTableViewCell(at: indexPath.row)
    }
}

// MARK: - UserDetailPresenterOutputCollection
extension UserDetailViewController: UserDetailOutputCollection {
    func loadUserInfo() {
        guard let user = presenter.user else { return }
        
        iconImageView.setImage(with: URL(string: user.avatarUrl))
        profileLabel.text = "ユーザ名: \(user.name)\nフルネーム: \(user.fullName ?? "登録なし")\nフォロワー数: \(user.followers)\nフォロー数: \(user.following)\n自己紹介: \(user.bio ?? "登録なし")"
        
        repositoryTableView.reloadData()
    }
    
    /// 詳細画面に移動する
    func moveToDetail(with urlString: String) {
        Router.shared.showWebView(with: urlString) { webVC in
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
}
