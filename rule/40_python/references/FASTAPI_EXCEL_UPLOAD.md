# FastAPI — Excel / CSV アップロード

**親 SSOT:** [`../FASTAPI_RULES.md`](../FASTAPI_RULES.md) §6

**用途:** ポートフォリオ第3柱（Next.js UI + FastAPI 処理）· 複数 Excel 統合 · 突合 · レポート生成 API。

**最終更新:** 2026-06-27

---

## 1. エンドポイント設計

| 方針 | 内容 |
|------|------|
| **REST** | `POST /api/v1/reports/merge` · `POST /api/v1/reports/reconcile` 等、**動詞は path に** |
| **入力** | `multipart/form-data` · 複数ファイルは同名 `files` または `files[]`（クライアントと合わせる） |
| **出力** | 小さい結果 → JSON · 大きい xlsx → **別 URL（S3/ローカル static）** または `Content-Disposition` 添付 |
| **非同期** | 処理 >30s 見込みなら **202 + job_id**（ポートフォolio 初期は同期で可 · タイムアウトに注意） |

---

## 2. UploadFile 実装要点

**公式:** https://fastapi.tiangolo.com/tutorial/request-files/

```python
from fastapi import UploadFile, File, HTTPException

MAX_BYTES = 10 * 1024 * 1024  # Settings から

async def read_upload_bounded(file: UploadFile, max_bytes: int) -> bytes:
    data = await file.read()
    if len(data) > max_bytes:
        raise HTTPException(status_code=413, detail="File too large")
    return data
```

| MUST | 理由 |
|------|------|
| `python-multipart` を依存に含める | 無いと UploadFile が動かない |
| 拡張子 + 内容スニッフ（任意） | `.xlsx` 偽装対策 |
| `await file.read()` 後に `await file.close()` または context | リーク防止 |
| 一時保存は `tempfile.NamedTemporaryFile(delete=False)` + `finally` で unlink | クラッシュ時のゴミ残り防止 |

---

## 3. service 層（pandas）例

```python
# app/services/report_merge.py
from pathlib import Path
import tempfile

import pandas as pd
from fastapi import HTTPException, UploadFile

from app.schemas.reports import MergeReportResponse, RowSummary

async def merge_excel_files(
    files: list[UploadFile],
    *,
    max_mb: int,
) -> MergeReportResponse:
    frames: list[pd.DataFrame] = []
    temp_paths: list[Path] = []
    try:
        for upload in files:
            suffix = Path(upload.filename or "data").suffix
            with tempfile.NamedTemporaryFile(suffix=suffix, delete=False) as tmp:
                content = await upload.read()
                if len(content) > max_mb * 1024 * 1024:
                    raise HTTPException(status_code=413, detail="File too large")
                tmp.write(content)
                temp_paths.append(Path(tmp.name))
            df = pd.read_excel(temp_paths[-1]) if suffix.lower() != ".csv" else pd.read_csv(temp_paths[-1])
            frames.append(df)
        merged = pd.concat(frames, ignore_index=True)
        # ビジネスルール（欠損行・ゴースト行）は PYTHON_RULES「データ完全性」に従う
        return MergeReportResponse(
            row_count=len(merged),
            columns=list(merged.columns.astype(str)),
            preview=merged.head(20).to_dict(orient="records"),
        )
    finally:
        for p in temp_paths:
            p.unlink(missing_ok=True)
```

**CPU バウンド:** 上記を sync のまま path operation から呼ぶとイベントループを塞ぐ。行数が大きい場合は `run_in_threadpool`（Starlette）または **バックグラウンドワーカー**へ。

---

## 4. レスポンススキーマ

```python
# app/schemas/reports.py
from pydantic import BaseModel, Field

class MergeReportResponse(BaseModel):
    row_count: int = Field(ge=0)
    columns: list[str]
    preview: list[dict[str, object]]  # 先頭 N 行のみ · 全件返さない

class ErrorDetail(BaseModel):
    detail: str
```

全データを JSON で返すと **メモリ · タイムアウト · 漏洩** のリスク。プレビュー + ダウンロードリンクが YK 既定。

---

## 5. Next.js フロント（接続のみ）

**詳細 SSOT:** [`../../30_web_stack/NEXTJS_RULES.md`](../../30_web_stack/NEXTJS_RULES.md)

```typescript
// 例: Client Component から直接 FastAPI（開発）
const form = new FormData();
for (const file of selectedFiles) form.append("files", file);
const res = await fetch(`${process.env.NEXT_PUBLIC_API_URL}/api/v1/reports/merge`, {
  method: "POST",
  body: form,
});
```

| 項目 | 方針 |
|------|------|
| **CORS** | FastAPI 側 `CORSMiddleware` · 本番は Next の origin のみ |
| **API URL** | `NEXT_PUBLIC_API_URL` · 秘密はフロントに置かない |
| **プロキシ** | 同一ドメインにしたい場合は Next **Route Handler** で reverse proxy（オプション） |

---

## 6. チェックリスト（実装前）

- [ ] `MAX_UPLOAD_MB` を Settings SSOT 化
- [ ] 空ファイル · 0 行 · 列不一致のエラーメッセージを定義
- [ ] TestClient で正常系 + 413 + 拡張子不正
- [ ] ログにファイル名以外の PII を出していない
- [ ] CLI 版と service 関数を共有し二重実装がない
