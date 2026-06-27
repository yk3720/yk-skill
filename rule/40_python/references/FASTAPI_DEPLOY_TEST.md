# FastAPI — テスト · デプロイ

**親 SSOT:** [`../FASTAPI_RULES.md`](../FASTAPI_RULES.md) §7 · §8

**最終更新:** 2026-06-27

---

## 1. TestClient 基本

**公式:** https://fastapi.tiangolo.com/tutorial/testing/

```python
# tests/conftest.py
import pytest
from fastapi.testclient import TestClient

from app.main import app
from app.config import Settings, get_settings

@pytest.fixture
def client() -> TestClient:
    def override_settings() -> Settings:
        return Settings(cors_origins=["http://test"], max_upload_mb=1)

    app.dependency_overrides[get_settings] = override_settings
    with TestClient(app) as c:
        yield c
    app.dependency_overrides.clear()
```

---

## 2. ファイルアップロードのテスト

```python
def test_merge_ok(client: TestClient, tmp_path):
    xlsx_bytes = b"..."  # 最小 valid fixture または tests/fixtures/sample.xlsx
    response = client.post(
        "/api/v1/reports/merge",
        files=[
            ("files", ("a.xlsx", xlsx_bytes, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")),
            ("files", ("b.xlsx", xlsx_bytes, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")),
        ],
    )
    assert response.status_code == 200
    body = response.json()
    assert body["row_count"] >= 0
```

| 追加ケース | 期待 |
|------------|------|
| 拡張子 `.exe` | 400 |
| サイズ超過 | 413 |
| files 未指定 | 422 |

---

## 3. pytest 実行

```bash
uv run pytest tests/ -q
uv run ruff check .
uv run mypy app
```

[`PYTHON_RULES.md`](../PYTHON_RULES.md) §7 と同じゲートを API リポでも適用。

---

## 4. Docker（本番向け最小）

**公式:** https://fastapi.tiangolo.com/deployment/docker/

```dockerfile
FROM python:3.12-slim
WORKDIR /code
COPY pyproject.toml uv.lock ./
RUN pip install uv && uv sync --frozen --no-dev
COPY app ./app
CMD ["uv", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

| 項目 | 方針 |
|------|------|
| **非 root ユーザー** | 本番イメージでは `USER` を切替 |
| **.env** | イメージに焼かない · ランタイム env |
| **ヘルスチェック** | `GET /health` → orchestrator 用 |

---

## 5. ホスティング選択（YK）

| 方式 | 向き | 注意 |
|------|------|------|
| **Railway / Render / Fly.io** | ポートフォolio · 副業デモ | 無料枠のスリープ · タイムアウト |
| **VPS + Docker** | 固定費 · 学習向け | 運用コスト |
| **Vercel（Next のみ）** | フロント | **FastAPI 本体は別** — Python Serverless は実行時間制限 |
| **AWS Lambda + Mangum** | 小規模 API | コールドスタート · pandas サイズ |

Next.js を Vercel、FastAPI を Railway 等に分ける構成が YK ポートフォolio の既定。

---

## 6. 本番起動 · Workers

**公式:** https://fastapi.tiangolo.com/deployment/server-workers/

```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 2
```

| 項目 | 方針 |
|------|------|
| **workers** | CPU コア数程度から調整 · **メモリに pandas が載る場合は workers 過多に注意** |
| **リロード** | `--reload` は **開発のみ** |
| **プロキシ** | TLS 終端は Nginx/Caddy · Uvicorn は HTTP |

---

## 7. 観測 · `/docs` 制御

```python
# 本番 Settings
app = FastAPI(
    title=settings.app_name,
    docs_url="/docs" if settings.enable_docs else None,
    redoc_url=None,
    openapi_url="/openapi.json" if settings.enable_docs else None,
)
```

| 項目 | 方針 |
|------|------|
| **ログ** | uvicorn access log + アプリ ERROR |
| **メトリクス** | ポートフォolio 段階では省略可 |
| **OpenAPI** | 開発で `/docs` 活用 · 本番は無効化可 |
