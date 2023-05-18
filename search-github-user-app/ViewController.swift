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
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            users = try await githubAPIClient.getUser()
            userTableView.reloadData()
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
        cell.textLabel?.text = users[indexPath.row].login
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    // セルタップ時に呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toUserDetail", sender: nil)
    }
}
