//
//  UserDetailViewController.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import UIKit

class UserDetailViewController: UIViewController {
    var userName: String = ""
    var user: User?
    var repositories: [Repository] = []
    var selectedRepositoryUrl: String = ""
    
    @IBOutlet weak private var iconImageView: UIImageView!
    @IBOutlet weak private var profileLabel: UILabel!
    @IBOutlet weak private var repositoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            async let fetchUser: () =  fetchUser()
            async let fetchNotForkedRepositories: () = fetchNotForkedRepositories()
            let _ = await (fetchUser, fetchNotForkedRepositories)
            
            await loadInfo()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebView" {
            let webVC = segue.destination as! WebViewController
            webVC.urlString = selectedRepositoryUrl
        }
    }
    
    private func fetchUser() async {
        user = await GitHubAPIClient.shared.getUser(with: userName)
    }
    
    private func fetchNotForkedRepositories() async {
        let fetchedRepositories = await GitHubAPIClient.shared.getRepositories(with: userName)
        
        repositories = fetchedRepositories.filter { $0.isFork == false }
    }
    
    private func loadInfo() async {
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
        let repo = repositories[indexPath.row]
        
        cell.textLabel?.text = "\(repo.name) / 言語：\(repo.language) / ⭐️\(repo.stargazersCount)"
        cell.detailTextLabel?.text = repositories[indexPath.row].description
        
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
