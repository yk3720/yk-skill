# Secrets Hygiene 規則
## 横断 Secrets SSOT — チェックリスト + 禁止パターン（実装手順は各ドメイン rule）

**用途:** 資格情報・トークン・セッションの **保管・共有・コミット** に関する横断方針。  
**関連:** [`GIT_WORKFLOW_RULES.md`](GIT_WORKFLOW_RULES.md) §2（コミット禁止）· [`GIT_TRACKING_RULES.md`](GIT_TRACKING_RULES.md)（生成物 · 追跡対象全体）· [`QUALITY_GATE_RULES.md`](../60_tooling/QUALITY_GATE_RULES.md)（`detect-private-key` hook · Push Protection）· 各ドメイン rule のセキュリティ節  
**Git 操作:** コミット / push のタイミング → `GIT_WORKFLOW_RULES.md`

**最終更新:** 2026-08-09（§3-1 エージェント Read による会話履歴汚染を追記）

---

## ⚡ エージェント必読チェックリスト

作業前・コミット前に確認する。

- [ ] `.env` · `.env.local` · `credentials.json` · `*token*.txt` 等を **Git に含めていない**（`.gitignore` 確認）
- [ ] API キー・パスワード・接続文字列の **値そのもの** をチャット・ログ・Issue・スクリーンショットに **貼っていない**
- [ ] 上記ファイルを **Read / 端末出力で会話に取り込んでいない**（ユーザー未貼付でも履歴に残る — §3-1）
- [ ] Playwright `auth/session.json` をコミット・共有していない
- [ ] GAS のトークンを **ソースコードに直書きしていない**（Script Properties）
- [ ] Vercel Sensitive 変数を **`********` のままコピーしていない**
- [ ] surge / FB 等の認証情報を **リポジトリに保存していない**
- [ ] `flowchart-studio` では pre-commit の **`detect-private-key`** が通る（機械チェック — 詳細は `QUALITY_GATE_RULES` §3）

---

## 1. 原則

| 原則 | 内容 |
|------|------|
| **最小露出** | シークレットは必要な実行環境だけに置く |
| **リポジトリ外** | 本番・検証用の秘密は Git 履歴に入れない |
| **チャット禁止** | キー・パスワード・URI 全文・セッションファイル内容を **チャットに貼らない** |
| **エージェント非読取** | `.env*` 等の秘密ファイルを **Read して会話文脈に載せない**（貼付と同じ露出） |
| **報告のしかた** | ファイル名 · 変数名 · 存在有無 · マスク（例: `sk-…xxxx`）のみ |

**例外は設けない。** デバッグで値が必要なときは、ユーザーが **ローカルで直接** 確認する（エージェントに全文を貼らせない · エージェントもファイル全文を読まない）。

---

## 2. コミット・リポジトリに含めないもの

**Git 方針の SSOT:** [`GIT_WORKFLOW_RULES.md`](GIT_WORKFLOW_RULES.md) §2。

| 種別 | 例 | 備考 |
|------|-----|------|
| 環境変数ファイル | `.env` · `.env.local` · `.env.*.local` | `.env.example` は値なしテンプレのみ可 |
| クラウド資格情報 | `credentials.json` · サービスアカウント JSON | |
| API トークン | `fb-api-token.txt` 等 | → commenting-visual-explainers README |
| 認証セッション | `auth/session.json` | → `50_gas_html_test/PLAYWRIGHT_RULES.md` §5 |
| その他 | ユーザー指定の秘匿ファイル | |

**新規プロジェクト:** シークレットを扱う時点で `.gitignore` に上記パターンを入れる。

---

## 3. チャット・ログ・成果物

| 禁止 | 代替 |
|------|------|
| `DATABASE_URL` · API キー · パスワードの **全文** | 「`.env.local` に `DATABASE_URL` を設定済み」等 |
| `session.json` の内容を貼る | 「`auth/session.json` が存在する」 |
| surge ログインのメール・パスワードを再掲 | 「`npx surge login` が必要」 |
| CI artifact にシークレットを含める | Secret Store · 環境変数 |

### 3-1. エージェントのファイル Read（会話履歴への間接露出）— MUST

**背景（2026-08）:** ユーザーがチャットに接続文字列を貼っていないのに、エージェントが `.env.local` を Read して値の有無を「確認」した結果、**パスワード付き URI が会話履歴に残った**。ユーザー向けの「チャットに貼るな」だけでは防げない。

| MUST | 内容 |
|------|------|
| **Read 禁止** | `.env` · `.env.local` · `.env.*.local` · `credentials.json` · `*token*.txt` · `auth/session.json` など **値に秘密が入りうるファイル**を、内容確認目的で Read しない |
| **確認のしかた** | ユーザーに「設定済みか」を聞く · または **値を出力しない**チェックのみ（例: キー名の有無をユーザー報告に頼る） |
| **応答禁止** | 誤って読めた場合も、URI · パスワード · トークンを **応答・引用・再掲しない**。直ちにローテーション（Rotate）を案内する |
| **Shell も同様** | `type` / `Get-Content` / `cat` で秘密ファイルを標準出力に出さない（ログ経由で履歴汚染） |

**Incorrect:** 「`.env.local` を Read して `DATABASE_URL` が入っているか確認する」  
**Correct:** 「`.env.local` に `DATABASE_URL=` を保存したら『できた』とだけ送ってください」→ アプリ起動やヘッダー表示で間接確認する

---

## 4. 保管の置き場所（概要）

| 領域 | 置き場所 | 詳細 SSOT |
|------|----------|-----------|
| **Python ツール** | `.env` + `.gitignore` | `40_python/PYTHON_RULES.md` §2 [K-016] |
| **Next / Vercel / Neon** | Vercel Environment Variables · ローカル `.env.local` | `30_web_stack/VERCEL_RULES.md` §0 |
| **GAS** | Script Properties | `50_gas_html_test/GAS_RULES.md` §4-2 |
| **Playwright** | `auth/session.json`（ローカル・gitignore） | `50_gas_html_test/PLAYWRIGHT_RULES.md` §5 |
| **surge.sh** | CLI がユーザーホーム側に保持（`surge login`） | 図解スキル（`creating-visual-explainers` 等）のデプロイ節 |
| **FB コメント API** | `fb-api-token.txt`（リポジトリ外・gitignore） | `commenting-visual-explainers` README |

**ソースコード:** トークン・パスワードを **直書きしない**（GAS · アプリ共通）。

---

## 5. ドメイン rule との分担

| 本ファイル | 各 `*_RULES.md` |
|------------|-----------------|
| 横断チェックリスト · 禁止パターン · 一覧 | 実装手順 · コード例 · ツール固有の落とし穴 |

矛盾時は **Governance**（`RULE_INDEX.md`）に従う。同順位ならユーザーに確認する。
