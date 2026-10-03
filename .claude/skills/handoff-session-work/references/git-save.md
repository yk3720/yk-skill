# 引き継ぎ終了 — Phase C（Git 保存）

**位置:** 終了モードの **Phase B（記録）のあと**、ユーザーへの完了報告の **直前**。

**意図:** 「引き継ぎして」等の終了依頼は、当ターンで **commit + push まで**含む（別途「コミットして」「push して」は不要）。

**手順の正本:** 本ファイルは実行順序・RUN 予算のオーケストレーションが中心。コマンド例は参考として示すが、ゲート（secrets · メッセージ草案等）・失敗時の詳細対応は `managing-git-yk` が正本。**secrets ゲートは省略できない** — `managing-git-yk` の SKILL.md を Read する手順（下記 C-1 の 1）を飛ばして commit しない。

| 段階 | スキル |
|------|--------|
| commit+push | `managing-git-yk`（**commit+push** · PR は含めない） |

---

## RUN 予算（必須）

**Run の定義:** 1 Run = Bash/Shell ツール呼び出し 1 回。

| 触ったリポ数 | Phase C の Shell **最大** | 備考 |
| ------------ | ------------------------- | ---- |
| 1            | **1 Run**                 | add + commit + push を 1 Bash（方式 B 使用時のみ 2 Run · 下記 C-3 参照） |
| 2            | **2 Run**                 | リポごと 1 Bash · **同一ターンで並列送信可** |
| 3            | **3 Run**                 | 同上 |
| N（4 以上）  | **N Run**                 | 同上（リポ数 = Run 数。上限なし） |

**Phase B 単独の `git status` Shell は禁止。** 状態確認は Phase C の Bash **先頭** `git status --short` に含める（別 Run にしない）。

**Post-C 専用 commit は禁止**（「§2 hash 同期」だけの 2 回目 push で Run が +1〜2 される — 下記 C-3）。

**PowerShell で git commit 禁止（Phase C）** — `$(cat <<'EOF'...)` は PowerShell で構文エラーになり **Run が倍化**する。加えて、構文エラー時に意図せず文が分割実行され、コミットメッセージの破損や不正なコマンド断片の実行につながる安全上のリスクもある（効率だけの制約ではない）。[commit-shell.md §最優先](../../managing-git-yk/references/commit-shell.md)

---

## 前提

- Phase A（整理）· Phase B（新規セッション MD · HANDOFF · README）· **Phase B+（Tier P 資料整合）** が完了している
- **Agent モード**（Shell 可 · 初回から **`required_permissions: ["all"]`**）
- ユーザー発話が **終了モード**（引き継ぎして · セッション終了 · 作業を保存 · 引き継ぎ終了）

**中断からの再開:** 前ターンで Phase C が一部リポだけ完了した状態で中断（ユーザーの「やめて」「待って」等）した場合、再開時は該当リポごとに `git status --short` と `git log origin/<branch>..HEAD --oneline` を確認し、未 push の commit が残っているリポだけを対象に C-1 を実行する（push 済みリポへの再 add/commit はしない）。

---

## 対象リポの列挙

1. [repo-routing.md](../../managing-git-yk/references/repo-routing.md) を Read（未読なら）
2. **触った Git ルート** — セッション §1-3 のパスから得たルート（重複除去）。**Phase B 用 git status Shell は使わない**
3. 0 ルートかつ変更パスも無い → Phase C をスキップし、§2 に「変更なし」と記録

---

## C-1 — add + commit + push（リポごと · 1 Bash）

1. **`managing-git-yk` の SKILL.md を Read**（未読なら）— **commit+push** · メッセージ草案 · secrets ゲート
2. **Bash ツール**で **1 コール** = `status --short`（任意）+ `add` + `commit` + `push`
3. メッセージ — セッション MD §1 を材料。短い日本語なら **`-m` 1 行**でよい（HEREDOC 失敗回避）
4. **C-1 と C-2 を別 Shell に分けない**（通常フロー限定 — C-3 **方式 B** の「commit のみ → Write → amend+push」という 2 本構成はこの禁止の対象外の別目的の手順）
5. マルチリポ — **リポごとに Bash 1 本**を **並列**で送る（2 リポ = 2 Run · 5 Run 禁止）
6. **commit と push の間は `&&` で連結しない** — `add`→`commit` が「nothing to commit」で終わっても、前ターンの未 push commit が残っていることがある。`&&` で連結すると commit の non-zero 終了で push が丸ごとスキップされ、その未 push commit が取り残される。push は commit の成否に関わらず試行する（変更が無ければ `Everything up-to-date` で無害に終わる）

```bash
cd "c:/yk-application/flowchart-studio" && git status --short && git add path1 path2 && git commit -m "docs: 要約（日本語）"; git push origin main
```

```bash
cd "c:/yk-memo" && git status --short && git add handoffs/... && git commit -m "handoff: session N 要約"; git push origin main
```

---

## C-2 — push

C-1 の同一 Bash 内に push まで含めた（`;` 連結 · C-1 手順6）ため **独立した C-2 Shell は不要**。push 失敗時のみ同一リポで `git push` **のみ** 1 本再試行する（`add`/`commit` は再実行しない · `managing-git-yk` の **push**）。

---

## C-3 — Post-C hash（追加 commit 禁止）

Phase B で Write 済みのセッション MD の §2 · 先頭表 `commit` 行を更新する方法は **2 択のみ**:

| 方式 | Run 増 | 手順 |
| ---- | ------ | ---- |
| **A（推奨）** | **0**（1 Run のまま） | §2 に hash を書かず、**C-4 完了報告**に `commit <hash>` を載せる。先頭表 `commit` は `Phase C 完了報告参照` |
| **B** | **+1**（2 Run になる） | commit を push と分けて 2 本目の Bash で amend + push（hash を Write ツールで埋めてから amend · 下記） |

**禁止:** push **後**の StrReplace → 別 `git add` → 別 commit → 別 push（Post-C 専用 Run）。

**Write ツールは Bash 呼び出しの「途中」には挿入できない**（別ツール呼び出しのため、1 本の Bash プロセス内で呼べない）。そのため方式 B は方式 A と異なり **必ず 2 Run になる** — 「Run を増やさない」ことを優先するなら常に方式 A を使う。

**マルチリポ時は方式 A のみ** — 方式 B はセッション MD が存在する `yk-memo` 自身の commit hash を自己参照する場合のみ安全。実装リポ（別 repo）の hash をセッション MD に埋めたい場合、方式 B は「実装リポの commit 確定 → その hash を yk-memo 側で amend」という順序依存が生じ、RUN 予算表の「同一ターンで並列送信可」と矛盾する。2 リポ以上が絡むときは方式 A（完了報告に hash を載せるだけ）に統一する。

### 方式 B — amend（hash を session MD に残す · 2 Run になる）

1. **1 本目の Bash** — C-1 の手順から **push を外し**、`status --short && add && commit` のみ実行（`git rev-parse HEAD` で直前 commit の hash を同じ Bash 内で取得可）
2. Write ツールでセッション MD の `commit` 行を hash で更新（ここが 1 本目と 2 本目の間の別ツール呼び出し）
3. **2 本目の Bash** を実行:

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
