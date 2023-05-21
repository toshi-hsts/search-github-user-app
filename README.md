# GitHubユーザ検索くん
GitHubのユーザ情報を調べられるアプリ

## 実行手順
1. プロジェクトを立ち上げる
```zsh
git clone git@github.com:toshi-hsts/search-github-user-app.git
cd/to/path
open ios-engineer-codecheck.xcodeproj
```
2. シミュレータor実機を起動　

## 開発環境
Xcode 14.3 

## 利用外部ライブラリ
- SDWebImage
（Swift Package Managerを利用して管理）

## 仕様　
🔸ユーザ一覧画面
- ユーザ検索機能
- 検索後一覧表示
- 検索結果の総数を表示
- 一覧にはアイコンとユーザ名を表示
- 各行を選択してユーザリポジトリ画面に遷移
- 一覧を下にスクロールすると追加読み込み
- 通信待ち時はローディング画面を表示
- エラー捕捉時はアラートを表示

🔸ユーザリポジトリ画面
- 上部にアイコン、ユーザ名、フルネーム、フォロワー数、フォロー数、説明文を表示
- 下部にforkedリポジトリではないユーザのリポジトリ一覧を表示
- 一覧にはリポジトリ名、開発言語、スター数、説明文を表示
- 各行を選択してWebView画面に遷移
- 一覧を下にスクロールすると追加読み込み
- 通信待ち時はローディング画面を表示
- エラー捕捉時はアラートを表示

## 操作動画
![demo](https://github.com/toshi-hsts/search-github-user-app/assets/80573353/731cda6f-9879-41bb-a6e1-89ce23254dc3)

## アラート画面
<img src="https://github.com/toshi-hsts/search-github-user-app/assets/80573353/e9d2a244-ff8c-431a-bd4d-868f5e328ee6" width=260>

<img src="https://github.com/toshi-hsts/search-github-user-app/assets/80573353/2c971514-cdaa-4950-b381-ee3d69111604" width=260>
