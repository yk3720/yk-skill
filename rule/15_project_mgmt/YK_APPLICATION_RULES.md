# YKアプリケーション管理規則
## YK Application Lifecycle — 独立リポジトリへの移行 v1

**用途:** `yk-application` フォルダで開発されるアプリの **ライフサイクル · 独立リポジトリ管理への移行基準** の SSOT。  
**ステータス:** active（L1）  
**関連:** `15_project_mgmt/APP_PROJECT_RULES.md`（アプリ開発一般）· `RULE_INDEX.md` No 18  

**最終更新:** 2026-06-29

---

## 1. YKアプリケーションの定義

`yk-application` は、**個別の Git リポジトリとして独立管理するアプリ** を集約する物理フォルダである。

| 項目 | 内容 |
|------|------|
| **物理パス** | `c:/yk-application/{app-slug}/`（**フラット** — 下記 §1-1） |
| **Git 管理** | **アプリ単位で独立**（`yk-tool` のモノレポには含めない） |
| **実例** | `flowchart-studio`（本線 React Flow · 2026-06-23 移行）· `tauri-practice`（学習スパイク）· `comment-studio` / `manual-studio` / `prompt-studio`（企画スタブ） |
| **セキュリティ** | Windows Defender 等の除外対象（開発効率優先） |

### 1-1. フラット構成（親スイートフォルダは作らない）

`yk-application` 直下に **アプリ slug フォルダだけ** を置く。`fa-suite` · `studio-suite` 等の **親スイート用フォルダは作らない**（ユーザーが明示した場合のみ例外）。

| 採用 | 不採用 |
|------|--------|
| `c:/yk-application/flowchart-studio/` | `c:/yk-application/fa-suite/flowchart-studio/` |
| `c:/yk-application/comment-studio/` | 複数アプリを 1 つの親でまとめるモノレポ風レイアウト |

新スタジオも **同階層の独立フォルダ** + **独立 Git** を前提とする。既存アプリを親フォルダへ **移動しない**。

---

## 2. 開発フェーズと管理方針

アプリの状態に応じて、管理場所と Git の扱いを切り替える。

| フェーズ | 状態 | 置き場 | Git 管理 |
|----------|------|--------|----------|
| **初期・実験** | scaffold 直後 · 学習用 | `c:/yk-application/` | 任意（ローカルのみ可） |
| **開発中** | 機能実装中 · 外部連携あり | `c:/yk-application/` | **必須（アプリ単位）** |
| **完成・運用** | 実用可能 · 安定稼働 | `c:/yk-application/` | 必須（独立リポジトリ継続） |

---

## 3. 独立リポジトリ管理への移行基準

以下のいずれかを満たした場合、独立した Git リポジトリとしての管理を本格化させる。

1.  **外部サービス連携:** Supabase, Vercel 等の外部サービスと連携し、環境変数（`.env`）やデプロイ設定が必要になったとき。
2.  **ある程度の完成度:** MVP（Minimum Viable Product）としての基本機能が実装され、継続的な機能追加やバグ修正が見込まれるとき。
3.  **再利用性:** 他のプロジェクトから参照される可能性がある、または単独でパッケージ化して配布する可能性があるとき。

---

## 4. 他リポジトリとの関係

| リポジトリ | 関係 |
|------------|------|
| **yk-memo** | 企画・設計書・handoffs を保持。`yk-application` 側のソースコードとはパスでリンクする。 |
| **yk-skill** | アプリで使用する技術スタックのルールを保持。 |
| **yk-tool** | 汎用的なツールやスクリプトを保持。特定のアプリに特化しない成果物を置く。横断スクリプトは [`yk-tool/scripts/`](c:/yk-tool/scripts/README.md) · 台帳は [`catalog.yaml`](c:/yk-tool/catalog.yaml)。 |

---

## 5. 運用ルール（Agent 向け）

1.  **パスの絶対指定:** `yk-application` 内のアプリを操作する際は、常に `c:/yk-application/{app-slug}/` の絶対パスを使用する（§1-1 · `fa-suite/` 等の中間パスは **書かない**）。
2.  **環境変数の保護:** `.env` 等の秘密情報は `SECRETS_HYGIENE_RULES.md` に従い、リポジトリにコミットしない。`.env.example` を作成する。
3.  **handoffs との同期:** アプリの Git 状態（コミットハッシュ等）は `yk-memo/handoffs/` 内のセッション MD に記録し、再開時に齟齬がないようにする。
4.  **既存フォルダの保護（MUST）:** 次は **ユーザーが当ターンで明示するまで** 行わない。  
    - 既存アプリディレクトリの **削除** · **移動**（`Move-Item` · `robocopy /MOVE` 等）  
    - 親スイートフォルダの **新設** と既存アプリの **取り込み**  
    - `.git` を含むツリー全体の **上書き** · **空フォルダ化**  
    構成を変える必要があるときは **1 問だけ** 確認し、承認後も **git clone / 新規 mkdir** を優先する（移動で済ませない）。
5.  **パス一括置換:** `c:/yk-skill/rule` · `c:/yk-memo` · `c:/yk-application` を横断する Shell 一括書き換えは禁止。必要なら **Grep → ファイル単位の StrReplace**（`60_tooling/AGENT_SHELL_RULES.md` §3-5）。
