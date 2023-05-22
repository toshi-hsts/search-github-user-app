//
//  Rooter.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/20.
//

import UIKit

final class Router {

    public static let shared = Router()

    /// root画面を表示する
    func showRoot(showHandler: (_ rootNC: UINavigationController) -> Void) {
        guard let rootVC = UIStoryboard(name: "Root", bundle: nil)
                .instantiateViewController(withIdentifier: "rootVC") as? RootViewController else { return }

        let rootNC = UINavigationController(rootViewController: rootVC)
        let rootPresenter = RootPresenter(view: rootVC)

        rootVC.inject(rootPresenter)
        showHandler(rootNC)
    }

    /// detail画面を表示する
    func showDetail(with userName: String,
                    showHandler: (_ detailVC: UserDetailViewController) -> Void) {
        guard let detailVC = UIStoryboard(name: "UserDetail", bundle: nil)
                .instantiateViewController(withIdentifier: "detailVC") as? UserDetailViewController else { return}

        let userDetailPresenter = UserDetailPresenter(view: detailVC, userName: userName)
        detailVC.inject(presenter: userDetailPresenter)

        showHandler(detailVC)
    }

    /// webView画面を表示する
    func showWebView(with urlString: String,
                     showHandler: (_ detailVC: WebViewController) -> Void) {
        guard let webVC = UIStoryboard(name: "WebView", bundle: nil)
                .instantiateViewController(withIdentifier: "webVC") as? WebViewController else { return}

        let webViewPresenter = WebViewPresenter(view: webVC, urlString: urlString)
        webVC.inject(presenter: webViewPresenter, urlString: urlString)

        showHandler(webVC)
    }
}
