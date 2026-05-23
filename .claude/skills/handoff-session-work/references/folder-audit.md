# handoffs フォルダ確認 — チェックリスト

**正本:** パス規則 · 終了ゲート · アーカイブ → [routing.md](routing.md)  
**用途:** スキル **確認モード**のみ。ファイルの移動・削除は行わない。

## 対象の決め方

| ユーザー指定 | スキャン範囲 |
|--------------|--------------|
| なし · 「handoffs 全体」 | `c:/yk-memo/handoffs/` 配下の各 `{project}/` |
| プロジェクト名 · `@.../workspace-layout/` | `c:/yk-memo/handoffs/{project}/` のみ |
| 特定セッション `@` | その MD を中心に、同フォルダの HANDOFF · README · 兄弟ファイル |

## チェック項目

| ID | 確認内容 | ⚠ の例 |
|----|----------|--------|
| H1 | `HANDOFF.md` が存在する | 無い |
| H2 | HANDOFF の「最新セッション」リンクが開ける | 死リンク |
| R1 | `{project}/README.md` の「最新」と HANDOFF が **同一ファイル** | `_3` vs `_7` の不一致 |
| S1 | ルート直下のセッション MD 一覧（`archive/` 除く） | 最新以外が残存（**整理→archive 先行**未実施 · 要整理） |
| S2 | **最新は 1 本**（HANDOFF が指すもの） | 複数が「最新」扱いの記述 |
| A1 | `archive/{YYYY}/` の件数 · 直近の移動先 | 空のままルートだけ増殖 |
| L1 | 移行期 `YK_*_SESSION*` · `*_NEXT_SESSION.md` がルートに残っていないか | 重複ストック |
| T1 | 最新セッション MD に §4 · §2 Git 表 · 依頼文がある（テンプレ準拠時） | 空欄 · `TBD` |
| T2 | 秘密らしき行（`api_key` · `password` · 長いトークン） | 検出時は BLOCKER として報告 |

パス規則の詳細は [routing.md](routing.md) を Read すること。本ファイルに再掲しない。

## 報告テンプレ（コピーして埋める）

```markdown
[確認] handoffs/{project または 全体}

## 1 行サマリー
{最新ファイル名 · 日付 · 重大な不整合の有無}

## 一覧
| 場所 | ファイル | 状態 |
|------|----------|------|
| ルート | HANDOFF.md | 恒久方針 |
| ルート | {最新セッション}.md | ★最新（HANDOFF と一致 / 不一致） |
| ルート | {その他}.md | superseded → archive 候補 など |
| archive/{YYYY}/ | N 件 | … |

## 不整合・注意（⚠）
- {H2 / R1 / S1 など ID と内容}

## 次にできること（実行しない）
1. **続きから** — §4 の 1 件を実行
2. **整理して** — superseded を archive 等（整理モード）
3. **引き継ぎ終了** — 整理→archive 先のうえで新規セッション（終了モード）
```

## 確認モードでやらないこと

- セッション MD の新規 Write（終了モード）
- §4 のタスク実行（再開モード）
- archive 移動 · 削除（整理モード · ユーザー明示後）
- 「GO」と言って作業に入る（提案は箇条書きのみ）
- **Shell ツール** — Cursor の RUN 承認は主に Shell で発生する。確認は **Glob + Read** で足りる（例: `handoffs/workspace-layout/HANDOFF.md` を Read、ルートの `*.md` は Glob）

## ユーザー向け（RUN を減らす依頼文）

```text
引き継ぎを確認して。Shell は使わず Read だけで。
```

```text
@handoffs/workspace-layout/HANDOFF.md の確認だけ。実行・整理・git は不要。
```
