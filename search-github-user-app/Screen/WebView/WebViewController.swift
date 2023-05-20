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
        guard let url = URL(string: urlString) else { return }
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
}
