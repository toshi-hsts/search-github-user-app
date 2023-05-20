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
    @IBOutlet weak private var repositoryListTitleLabel: UILabel!
    @IBOutlet weak private var loadingView: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getUser()
        startAnimatingIndicator()
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
    /// ユーザ情報を反映させる
    func loadUserInfo() {
        guard let user = presenter.user else { return }
        
        iconImageView.setImage(with: URL(string: user.avatarUrl))
        profileLabel.text = "ユーザ名: \(user.name)\nフルネーム: \(user.fullName ?? "登録なし")\nフォロワー数: \(user.followers)\nフォロー数: \(user.following)\n自己紹介: \(user.bio ?? "登録なし")"
        repositoryListTitleLabel.isHidden = false
        repositoryTableView.reloadData()
    }
    
    /// 詳細画面に移動する
    func moveToDetail(with urlString: String) {
        Router.shared.showWebView(with: urlString) { webVC in
            navigationController?.pushViewController(webVC, animated: true)
        }
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

// MARK: - UIScrollViewDelegate
extension UserDetailViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // スクロールの現在位置
        let currentContentOffsetY = repositoryTableView.contentOffset.y
        // スクロール可能な最大位置
        let maxContentOffsetY = repositoryTableView.contentSize.height - repositoryTableView.frame.height
        // 現在の位置からスクロールの最下部までの距離
        let distance = maxContentOffsetY - currentContentOffsetY
        // 最下部から一定距離に近づいたら追加読み込みする
        if distance < 50 {
            presenter.approachTableViewBottom()
        }
    }
}
