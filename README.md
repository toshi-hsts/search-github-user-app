# GitHubユーザ検索くん
GitHubのユーザ情報を調べられるアプリ

## 実行手順
1. プロジェクトを立ち上げる
```zsh
git clone git@github.com:toshi-hsts/search-github-user-app.git
cd/to/path
open search-github-user-app.xcodeproj
```
2. シミュレータor実機を起動　
3. レート制限を緩和する場合は、アクセストークンを設定する（設定しなくても動く） <br>
https://docs.github.com/ja/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
```swift
class Env {
    static let accessToken = "アクセストークン"
}
```

## 開発環境
Xcode 14.3

## ターゲット
iOS15以上

## 利用外部ライブラリ
- SDWebImage
（Swift Package Managerを利用して管理）
非同期取得とキャッシュが容易に実現できるため選定

## 仕様　
🔸ユーザ一覧画面
- ユーザ検索機能
- 検索後は一覧表示
- 検索結果の総数を表示
- 一覧にはアイコンとユーザ名とタイプを表示
- 各行を選択してユーザ詳細画面に遷移
- 一覧を下にスクロールすると追加読み込み
- 通信待ち時はローディング画面を表示
- エラー捕捉時はアラートを表示

🔸ユーザ詳細画面
- 上部にアイコン、ユーザ名、フルネーム、フォロワー数、フォロー数、説明文を表示
- 下部にforkedリポジトリではないユーザのリポジトリ一覧を表示
- 一覧にはリポジトリ名、開発言語、スター数、説明文を表示
- 各行を選択してWebView画面に遷移
- 一覧を下にスクロールすると追加読み込み
- リポジトリがない場合はない旨を表示
- 通信待ち時はローディング画面を表示
- エラー捕捉時はアラートを表示

## 操作動画
![demo](https://github.com/toshi-hsts/search-github-user-app/assets/80573353/6961acdf-d453-4f2b-810a-e381c0b78780)

## アラート画面
<img src="https://github.com/toshi-hsts/search-github-user-app/assets/80573353/8a7034d7-8e76-4010-bc82-b162b7ca81cd" width=260>

<img src="https://github.com/toshi-hsts/search-github-user-app/assets/80573353/3aa1c785-2e17-4559-b6a9-0194c34254f9" width=260>
