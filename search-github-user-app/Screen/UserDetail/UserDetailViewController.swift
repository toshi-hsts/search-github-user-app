//
//  UserDetailViewController.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import UIKit

class UserDetailViewController: UIViewController {
    var userWrapper: UserWrapper?
    let githubAPIClient = GitHubAPIClient()
    var user: User?
    var repositories: [Repository] = []
    var selectedRepositoryUrl: String = ""
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var repositoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let userWrapper else { return }
        
        Task {
            user = try await githubAPIClient.getUser(with: userWrapper.name)
            repositories = try await githubAPIClient.getRepositories(with: userWrapper.name)
            await setInfo()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebView" {
            let webVC = segue.destination as! WebViewController
            webVC.urlString = selectedRepositoryUrl
        }
    }
    
    private func setInfo() async {
        guard let user else { return }
        
        iconImageView.setImage(with: URL(string: user.avatarUrl))
        profileLabel.text = "ユーザ名: \(user.name)\nフルネーム: \(user.fullName ?? "登録なし")\nフォロワー数: \(user.followers)\nフォロー数: \(user.following)\n自己紹介: \(user.bio ?? "登録なし")"
        
        repositoryTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension UserDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        
        cell.textLabel?.text = repositories[indexPath.row].name
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension UserDetailViewController: UITableViewDelegate {
    // セルタップ時に呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedRepositoryUrl = repositories[indexPath.row].htmlUrl
        performSegue(withIdentifier: "toWebView", sender: nil)
    }
}
