# 引き継ぎ終了 — Phase C（Git 保存）

**位置:** 終了モードの **Phase B（記録）のあと**、ユーザーへの完了報告の **直前**。

**意図:** 「引き継ぎして」等の終了依頼は、当ターンで **commit + push まで**含む（別途「コミットして」「push して」は不要）。

**手順の正本:** 本ファイルはオーケストレーションのみ。実コマンド・ゲート・失敗時は子スキルに委譲する。

| 段階 | スキル |
|------|--------|
| commit | `committing-with-git-yk` |
| push | `pushing-and-pr-yk`（**push モードのみ** · PR は含めない） |

---

## 前提

- Phase A（整理）· Phase B（新規セッション MD · HANDOFF · README）· **Phase B+（Tier P 資料整合）** が完了している
- **Agent モード**（Shell 可）
- ユーザー発話が **終了モード**（引き継ぎして · セッション終了 · 作業を保存 · 引き継ぎ終了）

---

## 対象リポの列挙

1. [repo-routing.md](../../committing-with-git-yk/references/repo-routing.md) を Read（未読なら）
2. **触った Git ルート** — Phase B の §2 用 `git status` で列挙したルート + セッション §1-3 のパスから得たルート（重複除去）
3. 0 ルートかつ変更パスも無い → Phase C をスキップし、§2 に「変更なし」と記録

---

## C-1 — commit（リポごと）

1. **`committing-with-git-yk` の SKILL.md を Read** し、同スキルの手順 1〜6 を **ルートごと**に実行する
2. **開始ゲート（緩和）** — 終了モード依頼で同スキルのゲート 2・3 を満たす（HANDOFF に「次は commit」とあるだけでは不可のまま）
3. **メッセージ草案** — 新規セッション MD の §1（完了・決定）を材料にする。草案を提示し、**同ターン内**に修正指示がなければ add / commit へ進む（終了の一連操作として完結）
4. **スキップ** — 変更なし · secrets 疑い · `5.Python` の既存 rev 上書き → 子スキルどおり中止し、理由を §2 に 1 行

---

## C-2 — push（リポごと · commit 成功分）

1. C-1 で **commit したルート**（および「既に commit 済みで ahead のみ」のルート）に対し、**`pushing-and-pr-yk` の SKILL.md を Read** し **push モード**の手順を実行
2. **開始ゲート（緩和）** — 終了モード依頼で push ゲート 2 を満たす
3. **PR は含めない** — ユーザーが当ターンで PR を明示したときのみ `pushing-and-pr-yk` の pr / push+pr モード
4. 未コミットが残っているルート → push せず、§2 に理由を記録

---

## C-3 — セッション MD の追記（Post-C）

Phase B で Write 済みのセッション MD を **更新**（上書きではなく §2 と先頭表のみ）:

| 項目 | 記載例 |
|------|--------|
| 先頭表 `commit` | `終了時 commit+push 済` / `一部スキップ（理由）` |
| §2 表 | 各ルート: クリーン · `ahead 0` · 直近 `<hash>` 1 行 · push 済/未 |

---

## C-4 — 完了報告（ユーザー向け）

Phase B の保存パス・再開 `@` 文に加え、リポごとに:

```text
Git（Phase C）:
  <repo>: commit <hash> — <subject> · push 済
  <repo>: スキップ — <理由>
```

---

## Shell（AGENT_SHELL_RULES D-2）

- Phase B: 触ったルートの `git status`（従来どおり · 1 本 `;` 連結可）
- Phase C: **Bash ツール** で `add + commit + push` を **1 コール**にまとめる（[commit-shell.md §最優先: Bash ツール + HEREDOC](../../committing-with-git-yk/references/commit-shell.md)）。リポごとに 1 コール = 3 リポで 3 コール。

  ```bash
  cd "c:/yk-repo" && git add FILES && git commit -m "$(cat <<'EOF'
  メッセージ
  EOF
  )" && git push origin main
  ```

  **C-1 と C-2 を別コールに分けない。** 同ターンで commit + push するときは必ず 1 コールに束ねる。

---

## 禁止（Phase C）

- Phase A または Phase B（新規セッション Write）**より前**の commit / push
- **確認** · **整理**モードでの commit / push
- 子スキルが禁止する操作（force push to main/master · secrets の add 等）
