# Python 開発ルール
## YK Python ツール開発 — Design & Development Rules v1

**SSOT（本ファイル）:** `yk-skill/rule/40_python/PYTHON_RULES.md`  
**実行手順・ゲート:** スキル `creating-pythoncode-yk`（`.claude/skills/creating-pythoncode-yk/SKILL.md`）  
**詳細ナレッジ・テンプレ全文:** 上記スキルの `references/`  
**人間向けアーカイブ（rev 積層）:** `c:/1.cursor/5.Python/0.ルール・操作方法/`（入口: 同フォルダ `入口.md`）

**5.Python ワークスペース:** `.cursor/rules/python-dev-entry.mdc`（`**.py` 編集時に自動適用）

**ルーティング SSOT:** スキル `references/ROUTER.md`（tier + tag + Ref Plan）  
**他言語向け設計パターン:** [`../10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md`](../10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md)

**最終更新:** 2026-05-23  
**索引:** [`../RULE_INDEX.md`](../RULE_INDEX.md) · スキル執筆は [`../10_meta/SKILL_AUTHORING_RULES.md`](../10_meta/SKILL_AUTHORING_RULES.md)

---

## 0. エージェント向け — いつ何を読むか

| 段階 | 読むもの | タイミング |
|------|----------|------------|
| L1 | **本ファイル** `PYTHON_RULES.md` | 毎回・最初 |
| L2 | `creating-pythoncode-yk/SKILL.md` | スキル発火 or `.py` 作業時 |
| L2.5 | **Ref Plan**（チャット出力） | **コード編集前・必須**（Light は短形式 · 質問のみは不要） |
| L3 | `references/` の個別ファイル | **Ref Plan の `load` に列挙したものだけ** |

**禁止:** rev 付きアーカイブの全件 Read · `references/` の全件 Read。

**手順:** `ROUTER.md` で tier（Light/Standard/Full）と tag を決める → Ref Plan を出す → 列挙ファイルのみ Read。

---

## 1. 四大精神（要約）

1. **積層的必然** — 各 Step の成果物をその Step の完成形として扱い、後工程で手戻りしない。
2. **仕様先行** — プロジェクト仕様書を唯一の正解とし、コードは論理の鏡にする。
3. **論理的生存・データ完全性** — 欠損・サイレント失敗・ゴースト行を許さない（Excel・バリデーションは KB 参照）。
4. **工数削減・環境浄化** — `TODO:` / 一時ファイル / 重複定義を残さない。

---

## 2. アーキテクチャ — MUST

| 項目 | 規則 |
|------|------|
| 依存方向 | **UI → Schemas ← Core**（循環参照禁止） |
| ファイルサイズ | `app/` 内 1 ファイル **500 行以内**（超える前に分割） |
| 環境 | **uv** + `pyproject.toml` + `uv.lock` + `.python-version` |
| 静的解析 | **Ruff**（`ruff check --fix`）+ **mypy**（`uv run mypy`）をリリース前に実行 |
| エントリ | `main.py` 先頭で **インポート・ハイジーン [K-002]**（`sys.path` 聖域化） |
| パス | `sys.frozen` 判定で exe 内外を分離 **[K-001]** |
| 機密 | `.env` + `.gitignore` で秘匿 **[K-016]** — 横断: [`../10_meta/SECRETS_HYGIENE_RULES.md`](../10_meta/SECRETS_HYGIENE_RULES.md) |

起動例: `uv run python main.py`

---

## 3. 標準プロジェクト構成（要約）

```
project_root/
├── 仕様・管理/          # 仕様書・ADR・テスト定義書
├── pyproject.toml
├── uv.lock
├── main.py
├── clean.py
├── app/
│   ├── constants.py
│   ├── core/
│   ├── ui/
│   └── schemas/       # Pydantic 等
├── assets/  logs/  output/  temp/
└── プロジェクト名.code-workspace
```

詳細ツリー → スキル `references/ファイル構成について.md`

---

## 4. SDD 開発フロー（Spec-Driven Development）

| Step | 内容 |
|------|------|
| 0 | 本ルール + SKILL + **ROUTER.md** |
| 0.1 | **Ref Plan** 出力（未出力なら実装しない） |
| 0.5 | 納期があれば **1 箇所に固定**（tag `deadline`） |
| 1 | 目的・対象・制約・成功条件を短文で固定 |
| 2 | 最小差分方針。破壊的 I/O 変更の要否を判断 |
| 3 | 実装（新規: 骨格→最短経路→境界。修正: 再現→原因→最小修正） |
| 4 | 品質ゲート（チェックリスト → `references/` または下記 §7） |
| 5 | SSoT 監査（定数・仕様の二重定義がないか） |
| 6 | 完了報告（§8 の tier に従う） |

---

## 5. 思考の三層監査（全工程で実施）

- **抽出:** 今回の制約・参照ファイルを箇条書きで固定
- **写経:** 変更ごとに「どの規律・KB ID に基づくか」を自問
- **検挙:** 完了前に「破っていないか」を逆方向チェック（`TODO:`、SSoT 重複、手順スキップ）

---

## 6. 参照ルーティング

**SSOT（何をいつ Read するか）:** スキル `creating-pythoncode-yk/references/ROUTER.md` のみ。  
tier / tag / K-ID / Ref Plan テンプレ・パージ規則は **ROUTER に書かない**（本節へ複製しない）。

| やること | 参照 |
|----------|------|
| tier・tag を決める | ROUTER §2〜§4 |
| K-ID から KB を足す | ROUTER §5 |
| 実装前に Ref Plan を出す | Light → ROUTER §7 短形式 · Standard 以上 → §7 フル形式 · SKILL Step 0.1 |
| 読み過ぎを防ぐ | ROUTER §6（パージ） |
| **FastAPI · REST API · UploadFile** | [`FASTAPI_RULES.md`](FASTAPI_RULES.md)（No 42）— 本ファイルの uv/Ruff/SDD は **そのまま適用** |

**目次（KB 全体像が必要なときだけ）:** `references/Python_2_技術ナレッジベース_01_目次.md`

---

## 7. 品質ゲート（最小チェックリスト）

完了前に確認する（詳細は `references/ssot-audit.md` · `exemplar.md`）。

**Git hook / CI（`flowchart-studio` 等）:** Ruff · pre-commit の機械ゲートと hook 失敗時のエージェント行動 → [`../60_tooling/QUALITY_GATE_RULES.md`](../60_tooling/QUALITY_GATE_RULES.md) §4 · §5。本 §7 は **設計・監査の人手チェックリスト**。

- [ ] 仕様・定数・マジックナンバーが **1 箇所（SSoT）** にある
- [ ] UI / Core / Schemas の依存方向を破っていない
- [ ] `TODO:` / `FIXME:` を残していない（意図的なら理由をコメント）
- [ ] 既存の公開 I/O を不用意に変更していない
- [ ] Ruff / mypy を実行した（または実行不要な理由を明記）
- [ ] 設計墓場と矛盾する案を採用していない

---

## 8. 完了報告（tier）

| tier | いつ | 末尾に含めるもの |
|------|------|------------------|
| **Light** | 1〜2 ファイルの小修正 | **変更概要** · **読んだ refs**（三層監査は実施するが報告文には書かない） |
| **Standard** | 通常の機能追加・改善 | 変更概要 · 三層監査 · ネガティブ監査 · 影響範囲 · SSoT 確認 · 検証コマンド · **読んだ refs** |
| **Full** | 新規プロジェクト・リリース・配布 | Standard 項目 + 物理的計量 · 環境浄化 · ディレクトリツリー · **読んだ refs** |

儀式的な長文は **Full のときのみ** 必須。

---

## 9. Git・リビジョン運用

**横断方針（SSOT）:** [`../10_meta/GIT_WORKFLOW_RULES.md`](../10_meta/GIT_WORKFLOW_RULES.md) — commit / push / メッセージ / 禁止操作

| 対象 | 方針 |
|------|------|
| **yk-skill（本ルール・スキル）** | 履歴は **Git が SSoT**。`rule/` とスキルは通常ファイル名で更新 |
| **5.Python/0.ルール・操作方法** | **rev 積層**（ワークスペース `revision-protection`）。既存 rev ファイルの上書き禁止 |

---

## 10. テンプレート（新規時のみ）

| 成果物 | references |
|--------|------------|
| プロジェクト仕様書 | `Python_3_テンプレート_プロジェクト仕様書.md` |
| ADR | `Python_4_テンプレート_意思決定記録(ADR).md` |
| テスト定義書 | `Python_5_テンプレート_テスト定義書.md` |
| main.py | `Python_6_テンプレート_main.py.md` |
| pyproject.toml | `Python_7_テンプレート_pyproject.toml.md` |
| clean.py | `Python_8_テンプレート_clean.py.md` |

---

## 11. 変更時のルール

- ロード規則を変えるときは **`references/ROUTER.md` のみ**更新する（本ファイル §6 に表を戻さない）。
- 詳細ナレッジは **`references/` に追記**し、ROUTER の tag / ID 表に1行足す。
- `5.Python/0.ルール・操作方法` の rev ファイルは、ユーザー明示時以外 AI が編集しない。
- 他言語スキルを新設するときは [`../10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md`](../10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md) に従う。

---

## 12. YK パターン補足（openpyxl / データ処理）

### openpyxl: `data_only=True` でインメモリビルダーの数式セルが全 None になる

`load_workbook(path, data_only=True)` は Excel アプリが保存したキャッシュ値を読む。  
openpyxl 自身が保存したファイルにはキャッシュがないため、**数式セルの値が全部 `None`** になる。

- **対策:** 数式セルに依存する行を処理するときは `None` / 空文字フォールバックを用意する。  
- **アンチパターン:** フォールバックなしに `assert cell_value is not None` → テスト fixture で必ず落ちる。

### データ処理: 空行スキップは「フォールバック適用後」に判定する

セルが空に見えても数式 → None の場合があるため、「最初に空チェックでスキップ」すると有効行まで消える。

```python
# NG: フォールバック前にスキップ
if not any(cells):
    continue

# OK: フォールバックで値を埋めてから判定
value = raw_value or derive_from_fallback(idx)
if not value:
    continue   # 本当に空の末尾余白行のみここに到達
```
