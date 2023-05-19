//
//  RootInputCollection.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/20.
//

import Foundation

protocol RootInputCollection: AnyObject {
    var users: [UserWrapper] { get }
    func tapTableViewCell(at index: Int)
    func getUsers()
}
