# スキル作成 — Cursor 固有設定

**SSOT:** 本ファイル · **索引:** [`SKILL_AUTHORING_RULES.md`](../SKILL_AUTHORING_RULES.md) §5

---

## 5. Cursor 固有の設定ルール

### 5-1. スキルの配置・探索と `fullPath`

Cursor は起動時にスキルディレクトリを走査し、`SKILL.md` を自動検出する。次の場所に **`スキル名/`（= YAML `name` と同じフォルダ）/ `SKILL.md`** という形で置く。

| 場所 | スコープ |
|------|----------|
| `.agents/skills/` | プロジェクト |
| `.cursor/skills/` | プロジェクト |
| `~/.agents/skills/` | ユーザー（グローバル） |
| `~/.cursor/skills/` | ユーザー（グローバル） |

互換として **`.claude/skills/`** / **`.codex/skills/`**（および各 `~/` 下）からも読み込まれる。一覧・挙動の詳細は更新されうるため、[Agent Skills（Cursor Docs）](https://cursor.com/docs/skills) を正とする。

**`agent_skills` の `fullPath`：** RULES や設定で **特定の `SKILL.md` を絶対パスで明示登録**する。リポジトリ内の探索パスに置けば自動検出され、`fullPath` は「別場所のスキルを足す」「常にこのファイルを指す」などの補助として使う。

**モノレポ・ネストした配置：** リポジトリの深い階層（例: `apps/web/.cursor/skills/`）にスキルフォルダを置ける。その場合、そのディレクトリ**配下**のファイルを扱う文脈に限りエージェントに表される（ルートの `.cursor/skills/` とは適用範囲が分かれる）。フロントマターの `paths` を付けなくても、**置き場所でスコープが決まる**点に注意する。

```yaml
# RULES.md または settings での登録例（明示登録する場合）
agent_skills:
  - fullPath: "c:/your-skill-dir/.claude/skills/your-skill/SKILL.md"
```

- パスは**フォワードスラッシュ**（`/`）を使う（Windows でも `\` は避ける）
- `fullPath` は絶対パスで指定する

### 5-2. フロントマターのオプション（Cursor）

必須は引き続き `name` と `description`。**任意**のキー例（意味の詳細・追加キーは [Cursor Docs](https://cursor.com/docs/skills) に従う）:

| キー | 用途の要約 |
|------|------------|
| `paths` | グロブで「該当ファイルを扱うときだけ」スキルを表に出す |
| `disable-model-invocation` | `true` のとき、文脈自動適用せず **`/skill-name` 等の明示呼び出し時のみ** |
| `license` | ライセンス名または同梱ライセンスへの参照 |
| `compatibility` | 環境要件（パッケージ・ネットワークなど） |
| `metadata` | 任意のメタデータ |

レガシーの **`globs`** は引き続き解釈されるが、**新規は `paths` を使う**。

### 5-3. ツール名は `サーバー名:ツール名` 形式で書く

```markdown
# ❌ ツール名だけだと "tool not found" になる
BigQuery でスキーマを確認する

# ✅ サーバー名付きで書く
BigQuery:bigquery_schema でスキーマを確認する
```

### 5-4. 読み取り専用モード（Ask モード）への配慮

Cursor の Ask モード / 読み取り専用セッションでは**変更系ツールが使えない**。  
スキルに「ファイルを書き込む」手順がある場合は、Agent モードでのみ有効と明記するか、代替手順（コードを提示して「コピーしてください」）を書く。
