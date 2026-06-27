# FastAPI 参照ルール

## このルールが必要な背景

FastAPI は Python の型ヒントと Pydantic による **REST API サーバー**向けフレームワーク。Excel/CSV 処理など CLI で書いたロジックを HTTP で公開し、Next.js などのフロントから呼ぶときに YK の標準パターンを揃える。

**ファイルパス（エージェント参照用）:** `c:/yk-skill/rule/40_python/FASTAPI_RULES.md`

**ステータス:** `draft`（[`RULE_INDEX.md`](../RULE_INDEX.md) No 42）— L1 要約 + `references/` まで整備。**スキル `creating-fastapi-yk` · L0 entry · ROUTER は未整備**（PROGRESSIVE 段階 1）。

**親ルール:** [`PYTHON_RULES.md`](PYTHON_RULES.md)（uv · Ruff · mypy · SDD · 機密）— **FastAPI プロジェクトも Python 共通 MUST に従う**

**最終更新:** 2026-06-27（Web 調査に基づく初版）

---

## 0. エージェント向け — いつ何を読むか

| 段階 | 読むもの | タイミング |
|------|----------|------------|
| L1 | **本ファイル** | FastAPI · APIRouter · UploadFile · Uvicorn を触るたび・最初 |
| L1（共通） | [`PYTHON_RULES.md`](PYTHON_RULES.md) §2–§7 | 毎回（環境 · 品質ゲート · 機密） |
| L3 | 下記 §10 の `references/` | **該当節を触るときだけ**（全件 Read 禁止） |

**Ref Plan:** スキル未整備の間は、実装前にチャットで **tier · 触る節 · 読む references** を1行固定する。

### 読む深さ

| モード | 条件 | 読む節 |
|--------|------|--------|
| **Light** | 概念確認 · ルーティング質問のみ | §0 + §1 + §3 |
| **Standard** | 新規 API · ルータ追加 · CORS | §0–§5 · §7 · §10 索引 |
| **Deep** | Excel アップロード · 本番デプロイ · テスト追加 | Standard + §6 · §8 · §9 + 該当 `references/` |

### 本ファイルで扱わない（委譲 SSOT）

| 関心 | SSOT |
|------|------|
| uv · Ruff · mypy · SDD フロー · rev 積層 | [`PYTHON_RULES.md`](PYTHON_RULES.md) |
| Next.js UI · Route Handler · Server Actions | [`../30_web_stack/NEXTJS_RULES.md`](../30_web_stack/NEXTJS_RULES.md) |
| `.env` · API キー · トークン | [`../10_meta/SECRETS_HYGIENE_RULES.md`](../10_meta/SECRETS_HYGIENE_RULES.md) |
| Vercel への Python 配置（Next のみ等） | [`../30_web_stack/VERCEL_RULES.md`](../30_web_stack/VERCEL_RULES.md) — **FastAPI 本体は別ホストが基本** |
| Supabase Auth / RLS | [`../30_web_stack/SUPABASE_RULES.md`](../30_web_stack/SUPABASE_RULES.md) — ポートフォolio 薄 API では通常不要 |

### 誤ルーティング禁止

| 触るもの | 使う | 使わない |
|----------|------|----------|
| FastAPI ルータ · UploadFile · TestClient | **本ファイル** + `PYTHON_RULES` | `PYTHON_RULES` のみで API 構成を推測 |
| Excel 処理のコアロジック（CLI 共有） | `PYTHON_RULES` + 本ファイル §6 | ルータ内に pandas 全文 |
| フロントの fetch / フォーム UI | `NEXTJS_RULES` + `REACT_RULES` | 本ファイルに React 手順 |

---

## 1. FastAPI とは（要約）

| 項目 | 内容 |
|------|------|
| **用途** | 高速な **JSON/ファイル API**（OpenAPI 自動生成 · `/docs` で Swagger UI） |
| **基盤** | **Starlette**（ASGI）+ **Pydantic v2**（リクエスト/レスポンス検証） |
| **実行** | **Uvicorn**（または Hypercorn 等の ASGI サーバー） |
| **強み** | 型ヒントからの自動ドキュメント · `Depends` による DI · async/sync 両対応 |
| **公式** | https://fastapi.tiangolo.com/ — 索引 → [`references/FASTAPI_OFFICIAL_URLS.md`](references/FASTAPI_OFFICIAL_URLS.md) |

**YK で選ぶ典型理由:** Python で既にある Excel/CSV 集計・突合ロジックを **HTTP 1 本**に載せ、Next.js はアップロード UI と結果表示だけ担当する（ポートフォリオ第3柱）。

---

## 2. いつ使う / いつ使わない

| 使う | 使わない |
|------|----------|
| ファイルアップロード + サーバー側変換 | 画面全体を Python だけで作る（→ Next.js） |
| 既存 CLI/Python コアを API 化 | 単発スクリプト・バッチのみ（→ CLI のまま） |
| フロント複数（Web · 将来モバイル）から同じ処理を呼ぶ | 認可・DB 込みのフルスタック（→ Next + Supabase を先に検討） |
| OpenAPI で契約を明示したい | Django 管理画面が主目的 |

---

## 3. アーキテクチャ — MUST

| 項目 | 規則 |
|------|------|
| **依存方向** | **router → service → schemas**（ルータにビジネスロジックを書かない） |
| **ルータ** | `APIRouter` でドメイン分割 · `app.include_router(..., prefix=..., tags=...)` |
| **スキーマ** | **Request / Response を分離**（レスポンスに内部フィールドを漏らさない） |
| **型** | パラメータと `Depends` は **`Annotated[..., ...]`** を優先（公式推奨） |
| **設定** | **`pydantic-settings`** の `BaseSettings` · `@lru_cache` で1回読み · テストは dependency override |
| **async** | **I/O 待ち**（DB · 外部 HTTP · ディスク）のみ async · CPU バウンド（pandas 大量処理）は **sync 関数 + 別スレッド/ワーカー**を検討 |
| **1 関数 1 HTTP メソッド** | `@app.get` と `@app.post` を同一関数に混ぜない |
| **ファイルサイズ** | `PYTHON_RULES` と同様 **500 行/ファイル**を超えたら service / router 分割 |
| **環境** | **uv** + `pyproject.toml` · エントリは `[project.scripts]` または `uvicorn app.main:app` |

詳細ツリー → [`references/FASTAPI_PROJECT_STRUCTURE.md`](references/FASTAPI_PROJECT_STRUCTURE.md)

---

## 4. 最小アプリ骨格（YK ポートフォolio 向け）

```python
# app/main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import get_settings
from app.routers import reports

settings = get_settings()
app = FastAPI(title=settings.app_name, version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(reports.router, prefix="/api/v1/reports", tags=["reports"])
```

```python
# app/config.py — 概要のみ。詳細は references
from functools import lru_cache
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")
    app_name: str = "yk-report-api"
    cors_origins: list[str] = ["http://localhost:3000"]

@lru_cache
def get_settings() -> Settings:
    return Settings()
```

起動: `uv run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000`

---

## 5. ルーティング · DI · エラー

| パターン | 方針 |
|----------|------|
| **Depends** | DB セッション · Settings · 認可チェックは dependency に集約 |
| **HTTPException** | クライアントエラー（400/404/422） |
| **例外ハンドラ** | 予期しない例外は `@app.exception_handler` でログ + 500 整形 |
| **バリデーション** | Pydantic が足りない制約（例: ファイル拡張子）は dependency または service 入口で検証 |

公式: [Path Operations](https://fastapi.tiangolo.com/tutorial/path-params/) · [Dependencies](https://fastapi.tiangolo.com/tutorial/dependencies/)

---

## 6. Excel / CSV アップロード API（索引）

**詳細:** [`references/FASTAPI_EXCEL_UPLOAD.md`](references/FASTAPI_EXCEL_UPLOAD.md)

| MUST | 内容 |
|------|------|
| 受け口 | `UploadFile = File(...)` · **拡張子と MIME の両方**を検証 |
| サイズ上限 | Settings で **MAX_UPLOAD_MB** · 超過は 413 |
| 処理 | **`service/` で pandas/openpyxl** — ルータは `await file.read()` → service 呼び出しのみ |
| 一時ファイル | `tempfile` · 処理後 **必ず削除**（`try/finally`） |
| レスポンス | 集計結果 JSON または **生成ファイルの URL/ base64** — 巨大バイナリを無制限に inline しない |
| CORS | Next.js 開発 origin を `cors_origins` に含める |

CLI とロジック共有: `app/services/report_merge.py` を CLI からも import 可能に保つ（`PYTHON_RULES` §2 依存方向）。

---

## 7. テスト（索引）

**詳細:** [`references/FASTAPI_DEPLOY_TEST.md`](references/FASTAPI_DEPLOY_TEST.md) §1–§3

| 項目 | 方針 |
|------|------|
| **TestClient** | `from fastapi.testclient import TestClient` · `with TestClient(app) as client:` |
| **Settings override** | `app.dependency_overrides[get_settings] = lambda: Settings(...)` |
| **ファイル** | `client.post("/...", files={"file": ("a.xlsx", bytes, mime)})` |
| **pytest** | `tests/` をドメイン別 · `conftest.py` で app fixture |

---

## 8. デプロイ · 運用（索引）

**詳細:** [`references/FASTAPI_DEPLOY_TEST.md`](references/FASTAPI_DEPLOY_TEST.md) §4–§7

| 項目 | 方針 |
|------|------|
| **本番 ASGI** | `uvicorn app.main:app --host 0.0.0.0 --port $PORT --workers N`（CPU に応じて workers） |
| **リバースプロキシ** | Nginx / Caddy / クラウド LB の背後に置く |
| **ホスティング例** | Railway · Render · Fly.io · Docker on VPS — **Vercel は Python API 長時間処理向きではない** |
| **ヘルス** | `GET /health` をルータ外または dedicated router で提供 |
| **ログ** | 構造化ログ · リクエスト ID · **アップロード内容・PII をログに出さない** |

---

## 9. セキュリティ — MUST

| 項目 | 規則 |
|------|------|
| 認証 | 公開ポートフォolio は **API キー（Header）** または **ネットワーク制限** のどちらかを明示。未設定で全公開にしない |
| ファイル | 拡張子ホワイトリスト · サイズ上限 · zip ボム対策（必要なら行数上限） |
| CORS | `allow_origins=["*"]` は **本番禁止**（開発のみ） |
| Secrets | `.env` · [`SECRETS_HYGIENE_RULES`](../10_meta/SECRETS_HYGIENE_RULES.md) |
| OpenAPI | 本番で `/docs` を無効化する場合は `openapi_url=None` 等を Settings で切替 |

---

## 10. references 索引

| ファイル | いつ Read するか |
|----------|------------------|
| [`FASTAPI_OFFICIAL_URLS.md`](references/FASTAPI_OFFICIAL_URLS.md) | 公式ドキュメントの入口が必要なとき |
| [`FASTAPI_PROJECT_STRUCTURE.md`](references/FASTAPI_PROJECT_STRUCTURE.md) | 新規リポ構成 · ルータ分割 |
| [`FASTAPI_EXCEL_UPLOAD.md`](references/FASTAPI_EXCEL_UPLOAD.md) | UploadFile · pandas · レスポンス設計 |
| [`FASTAPI_DEPLOY_TEST.md`](references/FASTAPI_DEPLOY_TEST.md) | TestClient · pytest · Docker · 本番起動 |

---

## 11. 変更時のルール

- 詳細手順は **`references/` に追記**し、本ファイル §10 索引に1行足す。
- Python 共通（Ruff · SDD · 機密）を変えるときは **`PYTHON_RULES.md`** を更新する（本ファイルに複製しない）。
- PROGRESSIVE 完遂時: スキル `creating-fastapi-yk` · `ROUTER.md` · `.mdc` entry · 本ファイル `status: active` を [`RULE_INDEX`](../RULE_INDEX.md) と同期。
