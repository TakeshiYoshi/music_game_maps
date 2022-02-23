# OTOMAP

![site image](https://user-images.githubusercontent.com/71423029/133973943-256913f8-a47c-48ca-8a85-78b59ff599ab.png)
https://www.otomap.net/

# サービス概要
OTOMAPは音ゲーマーのゲームセンター探しをサポートするため以下のサービスを提供しています。
- 音楽ゲームに特化したゲームセンターマップ検索サービス
- ゲームセンターに設置された筐体の情報共有が出来るサービス

サービス正式リリース後、1日で多くのユーザーに使用して頂くことが出来ました。
- UU: 2,000 over
- PV: 13,000 over

# 機能
## 検索機能
| 現在位置周辺検索 | フィルター検索 |
| :-: | :-: |
| <img src="https://user-images.githubusercontent.com/71423029/133988249-5ba88e31-6829-41a4-882e-6466c09afd47.png" width="220px"> | <img src="https://user-images.githubusercontent.com/71423029/133989050-bc4776b2-94ba-458f-834a-451f8c1e869a.gif" width="220px"> |
| <div align="left">現在位置の周辺店舗を検索できます。</div> | <div align="left">条件を設定して店舗検索ができます。</div> |

| マップ検索 | フリーワード検索 |
| :-: | :-: |
| <img src="https://user-images.githubusercontent.com/71423029/133986230-fadb9ec7-4513-4ad5-bf6a-e45eabcf7342.gif" width="220px"> | <img src="https://user-images.githubusercontent.com/71423029/133990249-e7db70a4-3222-424f-948a-e6068c613f73.gif" width="220px"> |
| <div align="left">マップで表示している周辺の店舗を検索できます。</div> | <div align="left">フリーワードにて店舗検索が行えます。</div> |

## 情報投稿機能
| 情報投稿フォーム | 投稿一覧 |
| :-: | :-: |
| <img src="https://user-images.githubusercontent.com/71423029/133991601-09429e65-9845-4f38-828e-1c553ccdc1c3.gif" width="220px"> | <img src="https://user-images.githubusercontent.com/71423029/133991916-60125cb2-58a6-4422-ac4b-a9683cdd4301.gif" width="220px"> |
| <div align="left">画像添付や関連するゲーム機種のタグ付けが行えます。</div> | <div align="left">店舗詳細ページ内にて投稿一覧が確認できます。画像をクリックすると拡大プレビュができます。</div> |

## UI/UX
| テーマ変更 | チュートリアル |
| :-: | :-: |
| <img src="https://user-images.githubusercontent.com/71423029/133992646-328f90f4-6cb8-4c58-ab28-8770e0fa2cf1.gif" width="220px"> | <img src="https://user-images.githubusercontent.com/71423029/133992618-80b3ddce-af73-43dd-9c0a-18a23f5a3c7d.gif" width="220px"> |
| <div align="left">サイト全体のテーマを変更できます。</div> | <div align="left">初回アクセス時に限りチュートリアルを表示します。</div> |

# 主な使用技術
## バックエンド
- Ruby 3.1.0
- Rails 7.0.2
## フロントエンド
- Slim (HTML)
- Sass/SCSS (CSS)
- Bootstrap 5.0.0 (CSS)
- Vue.js 2.6.14 (JavaScript)
- axios (JS Package/Ajax)
- Leaflet (Map Preview)
- OpenStreetMap (Map Texture)

# 資料
## 画面遷移図
https://xd.adobe.com/view/4befa147-7997-4f29-8056-00eb881f1444-1ebc/grid
## デザインカンプ
https://xd.adobe.com/view/55c50a49-3e7a-4cbe-ad53-cb1111f13f2b-0096/grid
## ER図
![ERD](https://user-images.githubusercontent.com/71423029/133977878-d5713ac4-c1c9-4b78-9d4c-967e98a5f064.png)
## インフラ構成図
![インフラ構成図](https://user-images.githubusercontent.com/71423029/133975907-a12caf7f-4885-46ef-82b1-c599252f7bd8.png)
