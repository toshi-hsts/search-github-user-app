//
//  Int+Utility.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/21.
//

import Foundation

extension Int {
    /// 3桁区切りのコンマを付与する cf. 123,456,789
    func addComma() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        let number = "\(formatter.string(from: NSNumber(value: self)) ?? "")"

        return number
    }
}
