//
//  ViewController.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak private var userTableView: UITableView!
    
    let githubAPIClient = GitHubAPIClient()
    var users: [UserWrapper] = []
    var selectedUser: UserWrapper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            users = try await githubAPIClient.getUsers()
            userTableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserDetail" {
            let userDetailVC = segue.destination as! UserDetailViewController
            userDetailVC.userWrapper = selectedUser
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    // セル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    // セル設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let imageUrl = URL(string: users[indexPath.row].avatarUrl)
        
        cell.textLabel?.text = users[indexPath.row].name
        cell.imageView?.setImage(with: imageUrl)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    // セルタップ時に呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedUser = users[indexPath.row]
        performSegue(withIdentifier: "toUserDetail", sender: nil)
    }
}