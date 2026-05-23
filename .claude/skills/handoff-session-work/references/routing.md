# 引き継ぎ — 配置・命名 SSOT

本ファイルがパス・命名の唯一の正本。`SKILL.md` に同内容をコピーしない。

## 目次

- リポジトリと役割
- ディレクトリ一覧
- プロジェクト slug
- セッション MD の命名
- プロジェクト HANDOFF
- 最新セッションの正
- 資料整理（完了済みの掃除）
- 移行期（ルート `*_SESSION_*`）
- アーカイブ
- 既知プロジェクト例

---

## リポジトリと役割

| ルート | 引き継ぎでの役割 |
|--------|------------------|
| `c:/yk-memo` | `handoffs/`（セッション + プロジェクト HANDOFF） |
| `c:/yk-skill` | 本スキル · `rule/`（リンクのみ · 全文コピー禁止） |
| `c:/yk-tool` | 成果物リポ（触った場合 `git status` に含める） |
| `c:/yk-document` | データリポ（同上） |
| `c:/1.cursor/5.Python` | 別リポ（触った場合のみ status） |

横断パス SSOT → `c:/yk-skill/rule/RULE_INDEX.md` §リポジトリマップ

---

## ディレクトリ一覧（推奨 · 2026-05-23 以降）

```
c:/yk-memo/
  handoffs/
    README.md
    {project}/
      HANDOFF.md                  ← 恒久方針（プロジェクト 1 本）
      README.md                   ← 索引（任意）
      {YYYY-MM-DD}_{slug}.md      ← セッション 1 本
      archive/
        {YYYY}/                   ←  superseded セッション · 90 日超
  {PROJECT}_HANDOFF.md            ← 移行期のみ: 正本へのリダイレクト stub（任意）
```

| 種類 | 更新 | SSOT |
|------|------|------|
| セッション MD | 終了のたび **新規 Write** | `handoffs/{project}/{date}_{slug}.md` |
| プロジェクト HANDOFF | 方針変更時 + 終了時 **最新セッション 1 行** | `handoffs/{project}/HANDOFF.md` |
| テンプレ本文 | スキル改訂時のみ | `.../handoff-session-work/references/template.md` |

**yk-memo ルートに新規の `YK_*_SESSION*` · `YK_*_NEXT*` · 提案書を置かない。**

---

## プロジェクト slug

- **形式:** 小文字 · ハイフン区切り（例: `workspace-layout`）
- **フォルダ:** `c:/yk-memo/handoffs/{slug}/`
- 不明なときはユーザーに確認。推測で新 slug を作らない

---

## セッション MD の命名

| 条件 | ファイル名 |
|------|------------|
| 初回（その日） | `{YYYY-MM-DD}_{slug}.md` |
| 同日 2 回目以降 | `{YYYY-MM-DD}_2_{slug}.md` または `{YYYY-MM-DD}_{HHMM}_{slug}.md` |

- **既存セッション MD を上書きしない**

---

## プロジェクト HANDOFF

- **場所:** `c:/yk-memo/handoffs/{project}/HANDOFF.md`
- **更新:** 恒久方針は方針変更時のみ。セッション終了時は **「最新セッション」行** と §6 程度
- **禁止:** セッション MD 本文のコピー

### 「最新セッション」行の例

```markdown
| **最新セッション** | [`2026-05-23_2_physical-move-session-end.md`](2026-05-23_2_physical-move-session-end.md) |
```

### ルート stub（移行期 · 任意）

旧 `c:/yk-memo/YK_{PROJECT}_HANDOFF.md` を残す場合は **リダイレクトのみ**（本文を二重管理しない）:

```markdown
**正本:** [handoffs/{project}/HANDOFF.md](handoffs/{project}/HANDOFF.md)
```

---

## 最新セッションの正

1. **正:** `handoffs/{project}/HANDOFF.md` の「最新セッション」リンク
2. **フォールバック:** `handoffs/{project}/` を日付降順 glob（HANDOFF 未整備時のみ）

再開時は **セッション MD §4 の 1 件だけ**実行。

---

## 資料整理（完了済みの掃除）

セッション終了時、新規 MD を Write したあと **同プロジェクト内**を整理する（ユーザーが「整理して」と言ったとき、または終了フロー標準）。

### 残すもの

| 種類 | 例 |
|------|-----|
| プロジェクト HANDOFF | `handoffs/{project}/HANDOFF.md` |
| **最新**セッション MD | HANDOFF が指す 1 本 |
| `handoffs/README.md` · `{project}/README.md` | 索引 |
| `archive/` 内 | 過去セッション（参照用） |

### 削除してよいもの（完了・重複）

| 種類 | 例 | 条件 |
|------|-----|------|
| 実装済み提案書 | `YK_*_SKILL_PROPOSAL.md` | スキル／機能がリポに存在 |
| 移行期 `*_NEXT_SESSION.md` | ルートまたはプロジェクト直下 | 最新セッション §4 と重複 |
| 旧形式 `*_SESSION_*.md` | ルート | 内容が `handoffs/{project}/` に移行済み |

### アーカイブへ移動（削除しない）

| 種類 | 行き先 |
|------|--------|
|  superseded セッション MD | `handoffs/{project}/archive/{YYYY}/` |
| 同日の中間セッション（最新以外） | 同上（任意 · ユーザー確認可） |

### 整理後に必ず行うこと

1. `HANDOFF.md` の「最新セッション」が **1 本**を指すことを確認
2. `README.md` のリンクを更新
3. 削除・移動したファイル一覧を **新規セッション MD §1-3 またはユーザー向け報告**に 1 行ずつ記録
4. `rg` で死リンク（削除パスへの参照）が残っていれば **参照元だけ**修正（アーカイブ内の歴史記述は無理に直さない）

**禁止:** 最新セッション MD の削除 · HANDOFF 本文の丸ごと複製 · ユーザーの明示なしに `git commit`

---

## 移行期（ルート `*_SESSION_*`）

- 旧形式は **削除または stub 化**し、正本を `handoffs/{project}/` に集約
- 新規作業は必ず `handoffs/{project}/` へ

---

## アーカイブ

- **条件:** 最新でなくなったセッション MD、または日付から **90 日超**
- **操作:** `handoffs/{project}/archive/{YYYY}/` へ **移動**（セッション MD は原則削除しない）
- 毎回必須ではない。終了時整理またはユーザー依頼時

---

## 既知プロジェクト例

| slug | HANDOFF | 備考 |
|------|---------|------|
| `workspace-layout` | `handoffs/workspace-layout/HANDOFF.md` | ルート `YK_WORKSPACE_LAYOUT_HANDOFF.md` は stub |
| （別トラック） | `c:/yk-skill/rule/RULE_IMPROVEMENT_HANDOFF.md` | **本スキル非使用** |

新プロジェクト追加時は本表に 1 行追加する。
