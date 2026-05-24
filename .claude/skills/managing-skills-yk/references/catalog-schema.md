# SKILL_CATALOG スキーマ（SSOT）

**出力先:** `c:/yk-skill/metadata/SKILL_CATALOG.md`  
**混同禁止:** `c:/yk-tool/catalog.yaml`（成果物台帳）· `metadata/surge-published-list.md`（公開 URL 台帳）

---

## スキャン範囲

| 含める | パターン |
|--------|----------|
| 本番スキル | `c:/yk-skill/.claude/skills/**/SKILL.md` |
| サンプル | `c:/yk-skill/sample/**/SKILL.md` |

| 除外 | 理由 |
|------|------|
| `node_modules/` · `.git/` | 非スキル |
| `yk-skill` ルート直下の `SKILL.md` | Cursor 誤探索防止（置かない） |

---

## 列定義（メイン表）

| 列 | 由来 | 内容 |
|----|------|------|
| **No** | 生成時連番 | 表の並び（`name` 昇順推奨） |
| **name** | YAML `name:` | スキル識別子 |
| **skill_path** | ファイルパス | `yk-skill` 相対 · 常に `/` · `SKILL.md` まで |
| **tier** | パス規則 | 下表 |
| **canonical** | 人間 + 規則 | 下表 |
| **explicit_only** | YAML | `disable-model-invocation: true` なら `yes`、なければ `no` |
| **paths** | YAML（任意） | `paths` があるときのみ記載（例: `**/*.py`）。無ければ `—` |
| **notes** | 人間（最小） | 重複 · 親スキル · 要整理のみ。空欄可 |

### tier

| 値 | 条件 |
|----|------|
| **L1** | `.claude/skills/<1段目>/SKILL.md`（`<1段目>` 直下に SKILL.md がある） |
| **nested** | 上記以外で `.claude/skills/` 配下の SKILL.md（例: 親フォルダ内の `.claude/skills/...`） |
| **sample** | `sample/` 配下 |

### canonical

| 値 | 条件 |
|----|------|
| **yes** | 同名 `name` が複数あるときの **正本**（通常は L1 の方） |
| **no** | 同名の非正本（レガシー · バンドル内コピー） |
| **—** | 同名重複なし |

**同名重複の解消（Phase B1 · 2026-05-23）**

| 旧 name | 新 name | パス |
|---------|---------|------|
| `creating-visual-explainers`（nested のみ） | `creating-visual-explainers-fb` | `.claude/skills/commenting-visual-explainers/.claude/skills/creating-visual-explainers-fb/SKILL.md` |

L1 `creating-visual-explainers` は変更なし。同名 `name` の重複は解消済み（Phase B2 でフォルダ名も `creating-visual-explainers-fb` に揃え済み · 2026-05-23）。

---

## 更新タイミング（固定）

| トリガー | 更新するか |
|----------|------------|
| ユーザーがスキル整理・台帳更新を明示 | **する**（本スキル） |
| `creating-skills` が新規/更新を完了 | **する**（Step 8 — 同手順） |
| 任意スキルの通常実行・発火 | **しない** |

---

## フッター必須セクション

1. **ペア・要判断** — 関連スキルペア（例: L1 ↔ FB 版）を要約。`canonical=no` があればここに列挙
2. **sample** — tier=sample の表（本番表と分離可）
3. **関連** — surge 台帳 · yk-tool catalog へのリンク 1 行ずつ
