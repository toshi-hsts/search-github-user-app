//
//  UserDetailInputCollection.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/20.
//

import Foundation

protocol UserDetailInputCollection: AnyObject {
    var user: User? { get }
    var repositories: [Repository] { get }
    func tapTableViewCell(at index: Int)
    func getUser()
}
