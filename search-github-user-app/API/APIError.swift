//
//  APIError.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/21.
//

import Foundation

enum APIError: Error {
    case invalidSearchWord
    case notStatusCode
    case noResponseData(catchErrorText: String)
    case decodeFailure(statusCode: Int, catchErrorText: String)
    case clientFailure
    case networkFailure

    var description: String {
        switch self {
        case .invalidSearchWord:
            return "invalid search word"
        case .notStatusCode:
            return "status code is nil"
        case .noResponseData(let catchErrorText):
            return catchErrorText
        case .decodeFailure( _, let catchErrorText):
            return catchErrorText
        case .clientFailure:
            return "client error"
        case .networkFailure:
            return "server error"
        }
    }

    var alertMessage: String {
        var message = "通信環境が良い場所で再度お試しください。解決しない場合は〇〇までご連絡お願いします。"

        switch self {
        case .networkFailure:
            message = "メンテナンス中、もしくは障害が発生しています。ご迷惑おかけしますが\nしばらくお待ちください。"
        case .invalidSearchWord:
            message = "検索キーワードが正しく入力されていない可能性があります。再入力をお願いします。"
        default: break
        }

        return message
    }
}
