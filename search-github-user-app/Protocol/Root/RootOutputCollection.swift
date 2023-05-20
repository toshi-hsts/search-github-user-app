//
//  RootOutputCollection.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/20.
//

import Foundation

protocol RootOutputCollection: AnyObject {
    func moveToDetail(with userName: String)
    func tableReload()
    func setTotalCount(_ totalCount: Int)
    func startAnimatingIndicator()
    func stopAnimatingIndicator()
}
