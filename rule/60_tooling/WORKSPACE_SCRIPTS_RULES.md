# ワークスペーススクリプト配置 — yk-tool 正本

**用途:** 横断ユーティリティ・hook 用スクリプトの置き場 SSOT。  
**ステータス:** active（L1）  
**関連:** `RULE_INDEX.md` · `yk-tool/catalog.yaml` · `yk-tool/scripts/README.md`

**最終更新:** 2026-06-24

---

## 1. 結論（yk-skill vs yk-tool）

| リポ | スクリプトの役割 |
|------|------------------|
| **yk-tool** | **ワークスペース横断**の運用スクリプト · 台帳 `catalog.yaml` · `scripts/` |
| **yk-skill** | **スキル実行専用**（例: 図解 `deploy-diagram.sh`）— スキルと同じライフサイクル |
| **yk-application** | 製品リポ内の seed/dev 等 |
| **各 yk-tool アプリ** | アプリ専用 `scripts/`（例: ui-kit の drift 検査） |

**yk-skill に横断スクリプトを置かない。** 理由: yk-skill は rule/スキル（指示系）· yk-tool は成果物・実行系（[workspace-layout HANDOFF](c:/yk-memo/handoffs/workspace-layout/HANDOFF.md) §1）— 業界でも docs/rules と CLI/tools はリポ分離が一般的（例: [STOA ADR-003](https://docs.gostoa.dev/docs/architecture/adr/adr-003-monorepo-architecture)）。

---

## 2. エージェントが読む順

1. 本ファイル（置き場の判断）
2. [`c:/yk-tool/scripts/README.md`](c:/yk-tool/scripts/README.md) — 一覧 · 追加手順
3. [`c:/yk-tool/catalog.yaml`](c:/yk-tool/catalog.yaml) — `scripts:` · `hook_bindings:`

---

## 3. 新規スクリプト追加（要約）

1. ファイル → `yk-tool/scripts/`（横断の場合）
2. 登録 → `catalog.yaml` の `scripts:`
3. hook → 利用側リポに設定 + `catalog.yaml` の `hook_bindings:`
4. 検証 → `powershell -File c:/yk-tool/scripts/validate-catalog.ps1`

---

## 4. スキル内 scripts との境界

| 種別 | パス例 | 台帳 |
|------|--------|------|
| スキル専用 | `yk-skill/.claude/skills/*/scripts/` | `SKILL_CATALOG.md`（スキル単位） |
| 横断ユーティリティ | `yk-tool/scripts/` | `catalog.yaml` `scripts:` |

スキル MD から横断スクリプトを呼ぶときは **絶対パス** `c:/yk-tool/scripts/...` を書く。
