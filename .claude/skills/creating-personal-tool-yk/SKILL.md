---
name: creating-personal-tool-yk
description: >
  YK の自作ツールを新設する（デスクトップ・Web・CLI。言語は問わない）。
  発火例「自作ツールを作って」「新しいツールを作って」「ユーティリティを作って」「Webアプリのツールを作って」。
  Also for English: personal tool, desktop utility, web utility.
  Do NOT use for 既存コードの修正のみ（スタック別スキル）、企画パックや憲法だけの整備（starting-app-project-yk）、図解 HTML。
---

# Creating Personal Tool（YK）

日常使う **自作ツール** の新設を受け付ける。形態はデスクトップ GUI・Web・CLI があり、実装言語は Python に限らない。

**方針 SSOT:** No **18** `YK_APPLICATION_RULES.md`（置き場）· No **17** `APP_PROJECT_RULES.md`  
**実装:** `RULE_INDEX.md` のクイック入口でスタック別 L1 / スキルを選ぶ

---

## 依存

| 順 | 読むもの | いつ |
|----|----------|------|
| 1 | `c:/yk-skill/rule/15_project_mgmt/YK_APPLICATION_RULES.md` 置き場節 | 新設の最初 |
| 2 | スキル `starting-app-project-yk` | slug 確定後（新規モード） |
| 3 | `RULE_INDEX.md` クイック入口 → 該当 L1 | 実装に入るとき |
| 4 | スタック別スキル（下表） | コードを書くとき |

**参照実装（構成の型。ツリーはコピーしない）:**  
Python GUI: `c:/yk-application/bmp-resizer/` · `c:/yk-application/excel-shape-arranger/`  
複数ツールの集約（プラグイン方式）: `c:/yk-application/toolkit/`（旧 `excel-toolkit`。`app/core/` 契約 + `app/plugins/<name>/` を 1 フォルダ追加で拡張 · 元リポは温存）  
Web: `c:/yk-application/comment-studio/` · `c:/yk-application/lci-studio/`

---

## 使い分け

| 依頼 | 使う |
|------|------|
| 自作ツールを**新しく**（Web / デスクトップ / CLI） | **本スキル** |
| 既存ツールのコードを**直して** | スタック別（`creating-pythoncode-yk` · `creating-nextjs-yk` 等） |
| 企画フォルダ / AGENTS.md / handoffs **だけ** | `starting-app-project-yk` |

---

## ワークフロー

- [ ] Step 1: slug をユーザー確認（小文字 · ハイフン。推測で新設しない）
- [ ] Step 2: 置き場を決める — `YK_APPLICATION_RULES` 置き場節。迷ったら **yk-application 独立 Git**（推奨）
- [ ] Step 3: `starting-app-project-yk` **新規**に従い企画パック（独立リポならルート `AGENTS.md` + `docs/`）
- [ ] Step 3.5（**着手前ゲート · 必須**）: スタックの L1 を Read してからコードに触る。**Python は `PYTHON_RULES` L1（着手前チェック含む）と Ref Plan で tag `yk_desktop` + `exe` の L3（`PYTHON_YK_DESKTOP.md` · `PYTHON_PYINSTALLER_GUI.md`）を `load`。索引だけ読んで完了としない。** `creating-pythoncode-yk` の invoke がゲート。
- [ ] Step 4: 実装スキルへ委譲（下表）。**Python は必ず `creating-pythoncode-yk` を invoke**（Step 0「ルールを読む」＋ Ref Plan ゲートを通す）。他スタックも同様に該当スキルを invoke してから書く
- [ ] Step 5: Windows デスクトップ GUI は **同一ターンで exe をビルドする**（手順は `PYTHON_PYINSTALLER_GUI.md` · `PYTHON_YK_DESKTOP.md`）。bat は `dist\` の exe があればそれを起動する。ユーザーが「ソースだけ」と明示したときだけ省略。Web / CLI は各形態の起動手段
- [ ] Step 6: commit / push / GitHub は明示までしない

応答の先頭は `starting-app-project-yk` に合わせ `[新規]`。

### 実装の委譲（必須 · スタック別）

コードを書く前に該当スキルを invoke する（そのスキルの Step 0「ルールを読む」＋ Ref Plan ゲートが着手前の L1 読了を担保する）。詳細な発火は各スキルの `description`。迷ったら `RULE_INDEX` クイック入口。

| スタック | スキル |
|----------|--------|
| Python | `creating-pythoncode-yk` |
| Next.js `app/` | `creating-nextjs-yk` |
| React（Client） | `creating-react-yk` |
| 表駆動フロー | `creating-reactflow-yk` |
| 上記以外 | `RULE_INDEX` → 該当 L1 / スキル |

---

## やらない

| やらない | 代わり |
|----------|--------|
| `yk-tool` モノレポへ日常使う製品ツールを新設 | 置き場節の例外（ユーザー明示）だけ |
| 言語や形態を Python GUI に決め打ち | ユーザーの用途でスタックを選ぶ |
| 完成チェックリストの一括実装 | 1 セッション 1 件 |
| Windows GUI をソースだけで終える（exe なし） | Step 5。ユーザーが「ソースだけ」と明示したときだけ省略 |

---

## 関連

- 企画パック手順: `starting-app-project-yk`
- 置き場: `YK_APPLICATION_RULES.md` 置き場節
- 引き継ぎ: `handoff-session-work`
