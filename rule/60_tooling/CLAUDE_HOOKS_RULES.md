# Claude Code フック（YK 横断）

**目的:** Claude Code の **hooks** の仕組みと、YK 環境で現在動いているフックの一覧・発火条件を SSOT 化する。
**関連:** `60_tooling/claude-global/`（`~/.claude/CLAUDE.md` 正本・デプロイ）· `60_tooling/AGENT_SHELL_RULES.md` · `60_tooling/QUALITY_GATE_RULES.md`（lint/CI ゲート）· スキル `update-config`（settings.json 編集の手順）· `switching-tone-yk`（口調持続フック）

**ステータス:** draft（L1 あり · PROGRESSIVE 未完遂 · 専用スキル・L0 entry なし）
**最終更新:** 2026-09-10（新設 · active-tone フック追加時に一覧を起こした）

---

## 1. フックの仕組み

### 1-1. 何か

フック = Claude Code のライフサイクルの特定イベントで **シェルコマンドを実行**する仕掛け。
メモリ／設定では「イベントに反応して自動で何かする」はできない。それが要るときは必ずフック。

### 1-2. 設定場所と優先順位

| ファイル | スコープ | 用途 |
|----------|----------|------|
| `~/.claude/settings.json` | 全プロジェクト | YK の個人フックはここ（現状すべてここ） |
| `<repo>/.claude/settings.json` | プロジェクト | チーム共有（YK リポは現状フックなし） |
| `<repo>/.claude/settings.local.json` | 個人・非共有 | gitignore 対象 |

読み込み順は user → project → local（後が前を上書き）。フック配列は**マージ**される（同一イベントに複数エントリ可）。

### 1-3. 主なイベント

| イベント | matcher | いつ | ブロック可 |
|----------|---------|------|-----------|
| `SessionStart` | `startup` / `resume` / `clear` / `compact` | セッション開始・再開・/clear・圧縮後 | 不可 |
| `UserPromptSubmit` | （なし） | ユーザー送信直後・モデル応答前 | 可（`decision: block`） |
| `PreToolUse` | ツール名（`Write\|Edit` 等） | ツール実行前 | 可 |
| `PostToolUse` | ツール名 | ツール成功後 | — |
| `Stop` / `SessionEnd` | — | 応答終了・セッション終了 | — |
| `PreCompact` / `PostCompact` | `manual` / `auto` | 圧縮の前後 | — |

### 1-4. 入出力

- **入力:** stdin に JSON（`session_id` · `hook_event_name` · `tool_name` · `tool_input` · `source`（SessionStart）· `prompt`（UserPromptSubmit）等）。jq が無い環境が前提なので既存スクリプトは `sed` で抜く。
- **出力:** stdout に JSON を返すと挙動を制御できる。よく使うのは:
  - `hookSpecificOutput.additionalContext` — モデルのコンテキストへ**一行差し込む**（`SessionStart` / `UserPromptSubmit` / `PreToolUse` / `PostToolUse`）
  - `systemMessage` — ユーザーに通知だけ出す
  - `decision: "block"` + `reason` — ブロック系イベントで停止させる
- 出力しない（`exit 0`・無出力）なら「何もしない」。

### 1-5. 反映タイミング（既知の注意）

`settings.json` を編集しても、**設定ウォッチャーがそのセッション内で拾うとは限らない**
（セッション開始時に settings ファイルが存在したディレクトリのみ監視）。
即時に効かせたいときは `/hooks` を一度開く（設定リロード）か再起動。次回セッションからは確実。

---

## 2. 現在のフック一覧（YK · `~/.claude/settings.json`）

スクリプト本体は **`~/.claude/hooks/*.sh`**。2026-09-10 時点で **3 スクリプト・4 登録**。

| # | イベント | matcher | スクリプト | 何をする | ブロック |
|---|----------|---------|-----------|----------|----------|
| 1 | `SessionStart` | `startup\|resume` | `git-behind-check.sh` | コアリポ（yk-memo・yk-skill・yk-tool）を fetch し、origin より behind なら起動時に警告。pull はしない | しない |
| 2 | `SessionStart` | `startup\|clear` | `active-tone.sh reset` | 口調の状態ファイルを削除（前セッションの口調が新規会話へ漏れるのを防ぐ）。`resume` では消さない | しない |
| 3 | `UserPromptSubmit` | （なし） | `active-tone.sh inject` | 口調の状態ファイルがあれば「Active chat tone: `<slug>`」の一行を毎ターン差し込む | しない |
| 4 | `PreToolUse` | `Write\|Edit` | `yk-application-rule-reminder.sh` | `yk-application` 配下の `.py` を編集するとき、セッション1回だけ PYTHON_RULES §13/§14 の着手前チェックを促す | しない（非ブロッキング） |

いずれも `~/.cursor` の allowlist とは無関係（Claude Code 側の仕掛け）。
`timeout` は 1・4 が長め（fetch あり）、2・3 は 5 秒。

---

## 3. 各フックの詳細

### 3-1. `git-behind-check.sh`（#1）

- **発火:** セッション `startup` / `resume`
- **動作:** `REPOS="/c/yk-memo /c/yk-skill /c/yk-tool"` を順に `git fetch --quiet`（8 秒 timeout・端末プロンプト無効）→ `rev-list --left-right --count HEAD...@{u}` で behind を数え、1 件でもあれば `systemMessage` + `additionalContext` に「リモートが進んでいます（別PCの可能性）: …」を出す。
- **意図:** 複数 PC 運用で main が別 PC から進んでいることが多い。着手前に `git pull --rebase`／`syncing-repos-yk` を促す。
- **pull はしない**（判断はユーザー・スキル `syncing-repos-yk`）。

### 3-2. `yk-application-rule-reminder.sh`（#4）

- **発火:** `PreToolUse` で `Write` / `Edit`、かつ `tool_input.file_path` が `*yk-application*.py`
- **動作:** `~/.claude/.hook-cache/yk-apprule-<session_id>.done` があれば何もしない。無ければマーカーを作り、`additionalContext` に PYTHON_RULES §13/§14（StayOnTop・フォント統一・`[tool.ruff]` pin・`tk.StringVar`・`app/core` 分離・exe 再ビルド）の要点を出す。
- **意図:** yk-application の小型デスクトップ改修で毎回同じ着手前チェックを踏ませる。セッション1回に絞ってノイズを抑える。

### 3-3. `active-tone.sh`（#2 reset / #3 inject）

- **発火:** `inject` = `UserPromptSubmit`（毎ターン）· `reset` = `SessionStart` の `startup` / `clear`
- **状態ファイル:** `~/.claude/.hook-cache/active-tone` — 1 行目にプロファイル slug（例 `frieza`）。無い／空なら標準口調。
- **書き込み／削除は `switching-tone-yk` が担当**（口調適用時に slug を書き、「普段の口調に戻して」で `rm`）。
- **inject の中身:** slug を指す一行のみ。プロファイル本文（語尾・言い回し）は差し込まず、「会話履歴に無ければ読み直せ」と促すだけ。
- **意図:** ターン境界・要約・圧縮で口調が標準へ滑り落ちる取りこぼしを防ぐ。
- **既知の制限:** 状態ファイルは 1 個（セッション別でない）。複数の Claude Code を別口調で同時に走らせると混線する。`reset` が `startup` で消すため、セッションA が口調適用中にセッションB を起動すると A の次ターンで標準へ戻る。単一セッション運用なら問題ない。
- **削除手順:** `switching-tone-yk/SKILL.md`「口調持続フック（将来まとめて削除可）」節に、構成物 3 点セット（スクリプト・settings.json 2 ブロック・スキル手順）と手順を明記。

---

## 4. 状態キャッシュ

`~/.claude/.hook-cache/` にフックの状態を置く（git 管理外・セッションをまたいで残る）。

| ファイル | 書く人 | 消える契機 |
|----------|--------|-----------|
| `active-tone` | `switching-tone-yk` | 口調解除・`SessionStart(startup\|clear)` |
| `yk-apprule-<session_id>.done` | `yk-application-rule-reminder.sh` 自身 | 手動掃除のみ（セッションごとに増える） |

---

## 5. フックを追加・変更する手順

1. **スキル `update-config` を使う**（settings.json 編集の手順・スキーマ・pipe-test 手順が入っている）。
2. スクリプトは `~/.claude/hooks/<name>.sh` に置く。既存に倣う: `set -u` / stdin の JSON は `sed` で抜く / 出力は `printf '{"hookSpecificOutput":{"hookEventName":"…","additionalContext":"…"}}\n'` / 失敗しても `exit 0`（非ブロッキングなら）。
3. **pipe-test** してから登録: 想定 stdin を `echo '{…}' | bash <script>` で流し、終了コードと副作用を確認。
4. `settings.json` の該当イベント配列に**マージ**（既存エントリを消さない）。JSON 妥当性を確認（`python -c "import json,os;json.load(open(os.path.expanduser('~/.claude/settings.json'),encoding='utf-8'))"`）。
5. `/hooks` を開くか再起動して当セッションで反映（§1-5）。
6. 挙動が非自明なら本ファイル §2 の表と §3 に 1 項追加する。

---

## 6. 正本管理の現状と方針

- **現状:** `~/.claude/settings.json` と `~/.claude/hooks/*.sh` は **どのリポジトリにも入っていない**。別 PC には手で移す必要がある。
- **方針（未実施）:** `60_tooling/claude-global/` は現在 `CLAUDE.md` のみをデプロイ対象にしている。フック一式を版管理するなら、`claude-global/hooks/` と `claude-global/settings.json`（またはフック定義の断片）を追加し、`Deploy-ClaudeGlobal.ps1` をディレクトリ同期へ拡張する。着手時は本節を更新。
- それまでは本ファイルが「どのフックが何をしているか」の SSOT。スクリプトの中身の SSOT はスクリプト自身。

---

## 7. トラブルシュート

| 症状 | 対処 |
|------|------|
| settings.json を編集したのにフックが動かない | §1-5。`/hooks` を開くか再起動。JSON 壊れは全設定を無効化するので妥当性確認 |
| `SessionStart` フックの警告が出ない | ネットワーク／`git fetch` 失敗時は `git-behind-check.sh` が黙って `continue`。手動で `syncing-repos-yk` |
| 口調が毎ターン戻る／ずっと変なまま | `~/.claude/.hook-cache/active-tone` を確認。空にすれば標準へ。`switching-tone-yk` §「口調持続フック」 |
| `yk-apprule-*.done` が溜まる | 無害。気になれば `rm ~/.claude/.hook-cache/yk-apprule-*.done` |
| フックの stdout がトランスクリプトに漏れる | `suppressOutput: true` を返すか、JSON 以外を出さない |
