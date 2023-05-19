//
//  ViewController.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak private var userTableView: UITableView!
    

    var users: [UserWrapper] = []
    var selectedUserName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            users = try await GitHubAPIClient.shared.getUsers()
            userTableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserDetail" {
            let userDetailVC = segue.destination as! UserDetailViewController
            userDetailVC.userName = selectedUserName
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
        selectedUserName = users[indexPath.row].name
        performSegue(withIdentifier: "toUserDetail", sender: nil)
    }
}
