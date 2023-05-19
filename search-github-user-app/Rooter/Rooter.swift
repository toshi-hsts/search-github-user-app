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
}

