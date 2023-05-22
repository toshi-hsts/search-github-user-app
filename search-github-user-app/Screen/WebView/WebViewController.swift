//
//  WebViewController.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/19.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    private var presenter: WebViewInputCollection!
    private let webView = WKWebView()
    var urlString: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
    }

    private func loadWebView() {
        guard let url = URL(string: urlString) else {
            showErrorAlert(with: APIError.invalidSearchWord.alertMessage)
            return
        }
        let request = URLRequest(url: url)

        webView.frame = view.frame
        webView.load(request)
        view.addSubview(webView)
    }

    func inject(presenter: WebViewInputCollection, urlString: String) {
        self.presenter = presenter
        self.urlString = urlString
    }
}

// MARK: - RootOutputCollection
extension WebViewController: WebViewOutputCollection {
    /// エラー時のアラートを表示する
    func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "エラー",
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "再読み込み", style: .default, handler: { _ in
            self.loadWebView()
        }))
        present(alert, animated: true)
    }
}
