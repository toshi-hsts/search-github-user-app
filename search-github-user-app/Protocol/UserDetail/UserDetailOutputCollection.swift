//
//  UserDetailOutputCollection.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/20.
//

import Foundation

protocol UserDetailOutputCollection: AnyObject {
    func loadUserInfo()
    func moveToDetail(with urlString: String)
    func showNoResultView()
    func startAnimatingIndicator()
    func stopAnimatingIndicator()
    func showErrorAlert(with message: String)
}
