//
//  ViewController.swift
//  search-github-user-app
//
//  Created by ToshiPro01 on 2023/05/18.
//

import UIKit

class RootViewController: UIViewController {
    private var presenter: RootInputCollection!
    private let cell = "userCell"
    
    @IBOutlet weak private var userTableView: UITableView!
    @IBOutlet weak private var loadingView: LoadingView!
    @IBOutlet weak private var totalCountLabel: UILabel!
    @IBOutlet weak private var initialImageView: UIImageView!
    @IBOutlet weak private var userSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func inject(_ presenter: RootInputCollection) {
        self.presenter = presenter
    }
    
    private func setup() {
        navigationItem.backButtonTitle = "戻る"
        
        // キーボードに閉じるボタンをつける
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        let done = UIBarButtonItem(title: "閉じる",
                                   style: .done,
                                   target: self,
                                   action: #selector(tapCloseKeyboardButton))
        toolbar.items = [space, done]
        userSearchBar.inputAccessoryView = toolbar
        
        
        // setup xib
        userTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: cell)
    }
    
    // キーボード閉じる
    @objc func tapCloseKeyboardButton(_ sender: UIBarButtonItem) {
        userSearchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource
extension RootViewController: UITableViewDataSource {
    // セル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.users.count
    }
    
    // セル設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell, for: indexPath) as! UserTableViewCell
        let name = presenter.users[indexPath.row].name
        let imageUrlString = presenter.users[indexPath.row].avatarUrl
        
        cell.setup(name: name, iconUrl: imageUrlString)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension RootViewController: UITableViewDelegate {
    // セルタップ時に呼ばれる
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.tapTableViewCell(at: indexPath.row)
    }
}

// MARK: - RootOutputCollection
extension RootViewController: RootOutputCollection {
    /// 詳細画面に移動する
    func moveToDetail(with userName: String) {
        Router.shared.showDetail(with: userName) { detailVC in
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    /// テーブル更新
    func tableReload() {
        userTableView.reloadData()
    }
    
    /// total件数
    func setTotalCount(_ totalCount: Int) {
        totalCountLabel.text = "該当件数：\(totalCount.addComma())"
        totalCountLabel.isHidden = false
    }
    
    /// インジケーターを開始する
    func startAnimatingIndicator() {
        loadingView.startAnimatingIndicator()
        loadingView.isHidden = false
        view.isUserInteractionEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    /// インジケータを停止する
    func stopAnimatingIndicator() {
        loadingView.stopAnimatingIndicator()
        loadingView.isHidden = true
        view.isUserInteractionEnabled = true
        navigationController?.navigationBar.isUserInteractionEnabled = true
    }
    
    /// エラー時のアラートを表示する
    func showErrorAlert(with message: String) {
        let alert = UIAlertController(title: "エラー",
                                      message: message,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "再読み込み", style: .default, handler: { _ in
            self.presenter.getFirstPageUsers()
        }))
        present(alert, animated: true)
    }
}


// MARK: - UIScrollViewDelegate
extension RootViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // スクロールの現在位置
        let currentContentOffsetY = userTableView.contentOffset.y
        // スクロール可能な最大位置
        let maxContentOffsetY = userTableView.contentSize.height - userTableView.frame.height
        // 現在の位置からスクロールの最下部までの距離
        let distance = maxContentOffsetY - currentContentOffsetY
        // 最下部から一定距離に近づいたら追加読み込みする
        if distance < 50 {
            presenter.approachTableViewBottom()
        }
    }
}

// MARK: - UISearchBarDelegate
extension RootViewController: UISearchBarDelegate {
    // 検索ボタンがタップされるたびに呼ばれる
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchBar.text?.isEmpty == false,
              let searchWord = searchBar.text
        else { return }

        searchBar.resignFirstResponder()
        initialImageView.isHidden = true
        presenter.tapSearchButton(with: searchWord)
    }
}
