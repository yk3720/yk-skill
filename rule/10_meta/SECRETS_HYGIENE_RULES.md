# Secrets Hygiene 規則
## 横断 Secrets SSOT — チェックリスト + 禁止パターン（実装手順は各ドメイン rule）

**用途:** 資格情報・トークン・セッションの **保管・共有・コミット** に関する横断方針。  
**関連:** [`GIT_WORKFLOW_RULES.md`](GIT_WORKFLOW_RULES.md) §2（コミット禁止）· [`QUALITY_GATE_RULES.md`](../60_tooling/QUALITY_GATE_RULES.md)（`detect-private-key` hook · Push Protection）· 各ドメイン rule のセキュリティ節  
**Git 操作:** コミット / push のタイミング → `GIT_WORKFLOW_RULES.md`

**最終更新:** 2026-05-23

---

## ⚡ エージェント必読チェックリスト

作業前・コミット前に確認する。

- [ ] `.env` · `.env.local` · `credentials.json` · `*token*.txt` 等を **Git に含めていない**（`.gitignore` 確認）
- [ ] API キー・パスワード・接続文字列の **値そのもの** をチャット・ログ・Issue・スクリーンショットに **貼っていない**
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
| **報告のしかた** | ファイル名 · 変数名 · 存在有無 · マスク（例: `sk-…xxxx`）のみ |

**例外は設けない。** デバッグで値が必要なときは、ユーザーが **ローカルで直接** 確認する（エージェントに全文を貼らせない）。

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
