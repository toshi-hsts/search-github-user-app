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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let userWrapper else { return }
        
        Task {
            user = try await githubAPIClient.getUser(with: userWrapper.name)
        }
    }
}
