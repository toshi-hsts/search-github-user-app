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
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
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
    
    private func setInfo() async {
        guard let user else { return }
        
        iconImageView.setImage(with: URL(string: user.avatarUrl))
        nameLabel.text = user.name
        fullNameLabel.text = user.fullName
        followerLabel.text = "follwer数：　\(user.followers)"
        followingLabel.text = "follwing数：　\(user.following)"
        bioLabel.text = user.bio
        
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
}
