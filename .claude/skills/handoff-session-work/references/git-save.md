# 引き継ぎ終了 — Phase C（Git 保存）

**位置:** 終了モードの **Phase B（記録）のあと**、ユーザーへの完了報告の **直前**。

**意図:** 「引き継ぎして」等の終了依頼は、当ターンで **commit + push まで**含む（別途「コミットして」「push して」は不要）。

**手順の正本:** 本ファイルはオーケストレーションのみ。実コマンド・ゲート・失敗時は子スキルに委譲する。

| 段階 | スキル |
|------|--------|
| commit | `committing-with-git-yk` |
| push | `pushing-and-pr-yk`（**push モードのみ** · PR は含めない） |

---

## RUN 予算（必須）

| 触ったリポ数 | Phase C の Shell **最大** | 備考 |
| ------------ | ------------------------- | ---- |
| 1            | **1 Run**                 | add + commit + push を 1 Bash |
| 2            | **2 Run**                 | リポごと 1 Bash · **同一ターンで並列送信可** |
| 3            | **3 Run**                 | 同上 |

**Phase B 単独の `git status` Shell は禁止。** 状態確認は Phase C の Bash **先頭** `git status --short` に含める（別 Run にしない）。

**Post-C 専用 commit は禁止**（「§2 hash 同期」だけの 2 回目 push で Run が +1〜2 される — 下記 C-3）。

**PowerShell で git commit 禁止（Phase C）** — `$(cat <<'EOF'...)` は PowerShell で構文エラーになり **Run が倍化**する。[commit-shell.md §最優先](../../committing-with-git-yk/references/commit-shell.md)

---

## 前提

- Phase A（整理）· Phase B（新規セッション MD · HANDOFF · README）· **Phase B+（Tier P 資料整合）** が完了している
- **Agent モード**（Shell 可 · 初回から **`required_permissions: ["all"]`**）
- ユーザー発話が **終了モード**（引き継ぎして · セッション終了 · 作業を保存 · 引き継ぎ終了）

---

## 対象リポの列挙

1. [repo-routing.md](../../committing-with-git-yk/references/repo-routing.md) を Read（未読なら）
2. **触った Git ルート** — セッション §1-3 のパスから得たルート（重複除去）。**Phase B 用 git status Shell は使わない**
3. 0 ルートかつ変更パスも無い → Phase C をスキップし、§2 に「変更なし」と記録

---

## C-1 — add + commit + push（リポごと · 1 Bash）

1. **`committing-with-git-yk` の SKILL.md を Read**（未読なら）— メッセージ草案 · secrets ゲート
2. **Bash ツール**で **1 コール** = `status --short`（任意）+ `add` + `commit` + `push`
3. メッセージ — セッション MD §1 を材料。短い日本語なら **`-m` 1 行**でよい（HEREDOC 失敗回避）
4. **C-1 と C-2 を別 Shell に分けない**
5. マルチリポ — **リポごとに Bash 1 本**を **並列**で送る（2 リポ = 2 Run · 5 Run 禁止）

```bash
cd "c:/yk-application/flowchart-studio" && git status --short && git add path1 path2 && git commit -m "docs: 要約（日本語）" && git push origin main
```

```bash
cd "c:/yk-memo" && git status --short && git add handoffs/... && git commit -m "handoff: session N 要約" && git push origin main
```

---

## C-2 — push

C-1 に **`&& git push`** を含めたため **独立した C-2 Shell は不要**。push 失敗時のみ同一リポで **1 本**再試行（`pushing-and-pr-yk` Read）。

---

## C-3 — Post-C hash（追加 commit 禁止）

Phase B で Write 済みのセッション MD の §2 · 先頭表 `commit` 行を更新する方法は **2 択のみ**:

| 方式 | Run 増 | 手順 |
| ---- | ------ | ---- |
| **A（推奨）** | **0** | §2 に hash を書かず、**C-4 完了報告**に `commit <hash>` を載せる。先頭表 `commit` は `Phase C 完了報告参照` |
| **B** | **0** | C-1 の **同一 Bash 内**で push **前**に `git commit --amend`（hash を Write ツールで埋めてから amend · 下記） |

**禁止:** push **後**の StrReplace → 別 `git add` → 別 commit → 別 push（Post-C 専用 Run）。

### 方式 B — amend（hash を session MD に残す · 1 Run 維持）

1. C-1 の `git commit` の **直後** · **push 前**に、Write ツールでセッション MD の `commit` 行を更新（`git rev-parse HEAD` は直前 commit の hash — Bash 内で `HASH=$(git rev-parse HEAD)` 取得可）
2. **同一 Bash**を続けて実行:

```bash
git add "handoffs/flowchart-studio/SESSION.md" && git commit --amend --no-edit && git push origin main
```

amend 条件: User Rules `committing-changes-with-git` — HEAD が当エージェントの当ターン commit · **未 push**（本手順どおり）。

---

## C-4 — 完了報告（ユーザー向け）

Phase B の保存パス · 再開 `@` 文 · リポごとの hash（方式 A では **ここが hash の正**）:

```text
Git（Phase C · Run 予算: N リポ = N Run）:
  <repo>: commit <hash> — <subject> · push 済
  <repo>: スキップ — <理由>
```

---

## Shell（AGENT_SHELL_RULES D-2）

| Phase | Shell |
| ----- | ----- |
| B     | **git status 禁止**（Glob/Read + §1-3 のパス） |
| C     | **Bash** · リポ **1 本** · 初回 **`all`** · add+commit+push 連結 |

---

## 禁止（Phase C）

- Phase A または Phase B（新規セッション Write）**より前**の commit / push
- Phase B だけの `git status` / `git log` Shell
- **Post-C 専用 commit**（hash 同期の 2 回目 push）
- PowerShell の bash 風 HEREDOC commit
- C-1 commit と C-2 push の **別 Shell 分割**
- **確認** · **整理**モードでの commit / push
- 子スキルが禁止する操作（force push to main/master · secrets の add 等）
