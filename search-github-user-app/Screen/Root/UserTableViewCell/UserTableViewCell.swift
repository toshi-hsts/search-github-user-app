//
//  UserTableViewCell.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/20.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func setup(name: String, iconUrl: String) {
        userNameLabel.text = name
        iconImageView.setImage(with: URL(string: iconUrl))
    }
}
