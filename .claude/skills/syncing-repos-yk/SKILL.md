---
name: syncing-repos-yk
description: >
  複数の作業ディレクトリ配下にある git リポジトリを横断して fetch し、origin より遅れているものを検出する。
  作業ツリーが clean で fast-forward 可能なものは自動で pull --ff-only し、
  dirty・diverged・upstream不明・fetch失敗のものは理由付きで一覧化してユーザーに報告する。
  複数PCで作業していて、別PCでの変更をこのPCに素早く同期したいときに使う。
  「レポジトリを最新にして」「全リポジトリを同期して」「差分をpullして」「他のPCの変更を取り込んで」と依頼された際に使用する。
  Do NOT use for commit・push・PR作成・作業ツリーのクリーン（→ managing-git-yk）、単一リポジトリの通常の pull 作業。
---

# Repos Sync（YK）

複数リポジトリを横断して「遅れているか」を検出し、安全な範囲だけ自動で追従する。

## 依存

- pull/fetch の方針 SSOT: `c:/yk-skill/rule/10_meta/GIT_WORKFLOW_RULES.md` §1（破壊的マージ回避 = 常に `--ff-only`）
- 対象リポジトリの一覧: **ハードコードしない**。そのセッションの environment で見えている
  primary working directory + additional working directories を対象にする
  （ユーザーが「〇〇だけ同期して」等で対象を明示した場合はそちらを優先）

## 手順

1. environment の working directories から git リポジトリらしきパスを集める
2. 実行:
   ```
   bash scripts/sync-repos.sh <dir1> <dir2> ...
   ```
3. 出力（1行1リポジトリ、タブ区切り `STATUS\tpath\tbranch\tahead\tbehind\tdetail`）をステータス別に振り分ける:

   | STATUS | 意味 | 対応 |
   |--------|------|------|
   | `UP_TO_DATE` | 差分なし | 何もしない（列挙不要） |
   | `PULLED` | 自動で pull 済み | 何を取り込んだか一言報告 |
   | `DIRTY` | 遅れているが作業ツリーに変更あり | pull せず報告。stash するかはユーザーに確認 |
   | `DIVERGED` | 遅れつつ未push のローカルコミットもある | pull せず報告。マージ方針はユーザーに確認 |
   | `NO_UPSTREAM` / `DETACHED_HEAD` | 追跡ブランチなし | 報告のみ、放置してよい |
   | `FETCH_FAILED` / `PULL_FAILED` | ネットワーク等のエラー | detail のエラー内容をそのまま報告 |
   | `NOT_A_REPO` / `NOT_FOUND` | 対象外 | 無視（列挙不要） |

4. `DIRTY` / `DIVERGED` / `*_FAILED` があれば、リポジトリごとに一覧で報告し、次の一手をユーザーに確認する。
   **stash・force pull・reset は自動実行しない。**

## 出力方針

「まとめてOK」で終わらせず、実際に何件 fetch し、何件 pull し、何件が要対応かを数字で報告する。
