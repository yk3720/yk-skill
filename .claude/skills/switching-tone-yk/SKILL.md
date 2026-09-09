---
name: switching-tone-yk
description: YK 向けチャット応答の口調（トーン）を、ユーザーの明示指示で複数パターンに切り替える。「口調を変えて」「荒くれ者口調で」「フランクな口調で」「〇〇口調にできる?」「普段の口調に戻して」と依頼された際に使用する。同一会話で既に切替済みで未解除なら、要約・圧縮後も継続する（Active tone / 直近の切替指示を正とする）。Do NOT use for 文章の文体保存・起草（writing-in-my-voice-yk）、新規会話で口調指示が一度もない場合の通常応答（COMMUNICATION_RULES.md が既定）。
---

# Switching Tone（YK）

チャット応答の口調を、ユーザー明示指示でパターン切替する。
**新規会話で口調指示が一度もないときだけ**
`c:/yk-skill/rule/10_meta/COMMUNICATION_RULES.md`（No 16）の平易な標準口調。
同一会話で切替済み・未解除なら、要約後も含め継続する。

## 依存

- `c:/yk-skill/rule/10_meta/COMMUNICATION_RULES.md`（No 16）— 無指示時・解除時の既定口調（正本。本スキルは複製しない）

## 適用範囲（重要 · MUST）

口調は**演出**であり、作業の中身は変えない。パターンに関わらず常に維持する:

- 作業の正確さ・品質ゲート（テスト・lint・ドキュメント整合等）
- 安全側の判断（確認が要る操作は確認する、危険な操作は拒否する）
- ユーザーへの誠実な報告（失敗・想定外を隠さない）

## 持続（要約・圧縮耐性 · MUST）

会話が要約・コンテキスト圧縮されたあとでも、次のいずれかに **active tone** が残っていれば
解除指示があるまでそのプロファイルを読み直して適用する（標準口調へ勝手に戻さない）:

1. 要約本文の `Active tone` / `口調` / パターン名（例: frieza）
2. 直近ターンでの切替指示（「フリーザ口調で」等）と、その後に解除がないこと
3. フックが差し込む `Active chat tone: <slug>` の一行（下記「口調持続フック」）

解除は「普段の口調に戻して」「標準に戻して」等の**明示**のみ。要約で口調欄が消えただけは解除ではない。
迷ったら [references/tone-profiles.md](references/tone-profiles.md) を再 Read してから応答する。

## 手順

1. **パターンを特定する** — ユーザーが名指ししたらそれを使う。曖昧なら
   [references/tone-profiles.md](references/tone-profiles.md) の一覧を短く提示して選んでもらう。
   要約等に active tone がある場合はそれを継続（再確認の質問は不要）
2. **持続期間を確認する** — 「今だけ（このターン/この会話限り）」か「今後ずっと」かが
   文脈で不明なら1問だけ聞く。すでに明らかならスキップしてよい。未指定なら**この会話限り**（要約後も継続）
3. [references/tone-profiles.md](references/tone-profiles.md) から選んだパターン**1件だけ**を読み、
   語尾・一人称二人称・言い回し例を以降の応答へ適用する
4. **状態ファイルに slug を書く**（持続フック用 · 下記「口調持続フック」参照）:
   `printf '%s\n' '<slug>' > "$HOME/.claude/.hook-cache/active-tone"`（`mkdir -p` 済み前提）。
   これで毎ターン、フックが「Active chat tone: <slug>」の一行を差し込み、取りこぼしを防ぐ。
   書き忘れてもフックが黙って無効化されるだけで、従来どおり本スキルの指示ベースで継続する。
5. 「普段の口調に戻して」等の解除指示では `COMMUNICATION_RULES.md` の標準口調へ戻し、
   **状態ファイルを消す**: `rm -f "$HOME/.claude/.hook-cache/active-tone"`

## 口調持続フック（将来まとめて削除可）

口調は**退屈しのぎ**の側面がある機能で、いずれ不要になったら丸ごと外せるように分離してある。
取りこぼし（ターン境界・要約・圧縮で標準口調へ戻ってしまう）を防ぐための最小限の仕掛け:

**構成物（削除時はこの3点セットを消す）**

1. `$HOME/.claude/hooks/active-tone.sh` — `inject`（UserPromptSubmit）と `reset`（SessionStart）の2モード
2. `$HOME/.claude/settings.json` の `hooks` 内 2ブロック:
   - `UserPromptSubmit` → `active-tone.sh inject`
   - `SessionStart` matcher `startup|clear` → `active-tone.sh reset`
3. 本スキル手順の 4.（slug 書き込み）・5.（削除）と、状態ファイル `$HOME/.claude/.hook-cache/active-tone`

**動作**

- `inject`: 状態ファイルがあれば、その slug を指す一行だけを毎ターン差し込む。
  プロファイル本文は差し込まない（会話履歴に無ければ読み直す、と促すだけ）。
- `reset`: 新規セッション（`startup`）と `/clear` で状態ファイルを削除。前セッションの
  口調が新しい会話へ漏れない。`resume` では消さない（会話の続き＝口調も継続）。

**既知の制限**

- 状態ファイルは1個（セッション別ではない）。複数の Claude Code を同時に別口調で走らせると
  混線する。単一セッション運用なら問題ない。
- `reset` は `startup` で状態を消すため、セッションAが口調適用中にセッションBを起動すると
  Aの次ターンで標準へ戻る。稀。

**削除手順（不要になったら）**

1. `settings.json` から上記2ブロックを削除
2. `rm $HOME/.claude/hooks/active-tone.sh`
3. `rm -f $HOME/.claude/.hook-cache/active-tone`
4. 本スキル手順を 4.→旧3.、5.→旧4. に戻し、本節を削除

**変更履歴**

- 2026-09-10 新設。frieza 口調セッション中、圧縮なしのターン境界で標準口調へ取りこぼした
  のを受けて。1行差し込み方式（プロファイル本文は差し込まない）をユーザーと確認して採用。

## 新しいパターンを追加するとき

ユーザーが今回使った口調を保存したいと言ったら、
[references/tone-profiles.md](references/tone-profiles.md) に1パターン追記する
（既存パターンの記述は変えない）。追記する情報:

- パターン名（英語スラッグ + 日本語名）
- 語尾・一人称・二人称の指定
- 再現用の言い回し例 2〜3個
- 由来（初出セッション日・きっかけ、分かれば）
