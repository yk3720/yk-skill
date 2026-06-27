# FastAPI — プロジェクト構成

**親 SSOT:** [`../FASTAPI_RULES.md`](../FASTAPI_RULES.md) §3 · §4

**最終更新:** 2026-06-27

---

## 1. 規模別テンプレート

### 1-A. 小規模（YK ポートフォolio · 単一ドメイン）

CLI と API を同じリポに載せる想定。**1 ドメイン（reports 等）** なら十分。

```
report-api/
├── pyproject.toml
├── uv.lock
├── .python-version
├── .env.example
├── README.md
├── app/
│   ├── __init__.py
│   ├── main.py              # FastAPI factory · CORS · include_router
│   ├── config.py            # BaseSettings + get_settings @lru_cache
│   ├── dependencies.py      # 共通 Depends（任意）
│   ├── routers/
│   │   ├── __init__.py
│   │   └── reports.py       # APIRouter · 薄い path operations
│   ├── schemas/
│   │   └── reports.py       # Request/Response Pydantic models
│   └── services/
│       └── report_merge.py  # pandas 等 · CLI からも import 可
├── cli/
│   └── run_report.py        # 既存 CLI エントリ（任意）
├── tests/
│   ├── conftest.py
│   └── test_reports.py
├── temp/                    # gitignore · アップロード一時
└── output/                  # 生成物（任意）
```

### 1-B. 中〜大規模（ドメイン分割）

[公式 Bigger Applications](https://fastapi.tiangolo.com/tutorial/bigger-applications/) と [fastapi-best-practices](https://github.com/zhanymkanov/fastapi-best-practices) に沿い、**ビジネスドメイン単位**でパッケージを分ける。

```
src/
├── main.py
├── config.py
├── reports/
│   ├── router.py
│   ├── schemas.py
│   ├── service.py
│   ├── dependencies.py
│   └── constants.py
└── users/                   # 将来追加
    └── ...
```

YK では **1-A から開始**し、ルータまたは service が 500 行に近づいたら 1-B へ移行する。

---

## 2. ファイル責務

| ファイル | 責務 | 禁止 |
|----------|------|------|
| `main.py` | App 生成 · middleware · router 登録 | path operation 本体 |
| `routers/*.py` | HTTP 入出力 · Depends 配線 · HTTPException | pandas 処理 · 50 行超のロジック |
| `schemas/*.py` | Pydantic v2 モデル · Field 制約 | DB アクセス |
| `services/*.py` | ビジネスロジック · ファイル I/O | Request/Response 型の直接返却以外の HTTP 知識 |
| `config.py` | 環境変数 · CORS origins · 上限値 | 実行時の可変グローバル |

---

## 3. pyproject.toml（最小例）

```toml
[project]
name = "yk-report-api"
version = "0.1.0"
requires-python = ">=3.12"
dependencies = [
    "fastapi[standard]>=0.115",
    "pydantic-settings>=2.0",
    "python-multipart>=0.0.9",  # UploadFile / Form に必須
    "pandas>=2.2",
    "openpyxl>=3.1",
]

[project.optional-dependencies]
dev = ["pytest>=8.0", "httpx>=0.27", "ruff>=0.8", "mypy>=1.13"]

[tool.ruff]
line-length = 100
target-version = "py312"

[tool.mypy]
python_version = "3.12"
strict = true
```

起動（開発）:

```bash
uv run uvicorn app.main:app --reload --port 8000
```

---

## 4. ルータパターン

```python
# app/routers/reports.py
from typing import Annotated

from fastapi import APIRouter, Depends, File, HTTPException, UploadFile

from app.config import Settings, get_settings
from app.schemas.reports import MergeReportResponse
from app.services.report_merge import merge_excel_files

router = APIRouter()

def valid_excel(file: UploadFile) -> UploadFile:
    if not file.filename or not file.filename.lower().endswith((".xlsx", ".xls", ".csv")):
        raise HTTPException(status_code=400, detail="Unsupported file type")
    return file

@router.post("/merge", response_model=MergeReportResponse)
async def merge_reports(
    files: Annotated[list[UploadFile], File(...)],
    settings: Annotated[Settings, Depends(get_settings)],
) -> MergeReportResponse:
    for f in files:
        valid_excel(f)
    return await merge_excel_files(files, max_mb=settings.max_upload_mb)
```

`include_router` は `main.py` のみ。サブルータをネストするときも **公式の include_router API** を使い、`router.routes` を直接 mutate しない（[公式注意](https://fastapi.tiangolo.com/tutorial/bigger-applications/)）。

---

## 5. Pydantic v2 要点

| v1 系 | v2 |
|-------|-----|
| `class Config:` | `model_config = ConfigDict(...)` |
| `orm_mode = True` | `from_attributes=True` |
| `@validator` | `@field_validator` |

Request と Response は **別モデル**。DB エンティティをそのまま返さない。

---

## 6. PYTHON_RULES との接続

| PYTHON_RULES | FastAPI での適用 |
|--------------|------------------|
| uv + pyproject | そのまま |
| UI → Schemas ← Core | router → schemas ← services |
| Ruff / mypy | API リポでもリリース前必須 |
| `.env` + gitignore | `config.py` + SECRETS_HYGIENE |
