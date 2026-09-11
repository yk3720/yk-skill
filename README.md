# yk-skill

Claude Code / Cursor 向けの個人用スキル・ルール基盤。`.claude/skills/` と `rule/` を**1つの体系**として運用しており、あえて2つのリポジトリに分けていません（2026-09-11 検討・分割見送り）。

## なぜ1リポジトリか

- `rule/RULE_INDEX.md` が定義する **L0(`.cursor/rules/*.mdc`) → L1(`rule/*.md`) → L2(スキル `SKILL.md`) → L3(`references/`)** は一本のパイプラインで、スキルはルールを絶対パス `c:/yk-skill/rule/...` で参照する
- 他リポ（`yk-memo` / `yk-tool` / `yk-application` / `yk-document`）からもこの絶対パスで参照されている（横断で 200 ファイル超）
- スキルとルールは同一セッション・同一コミットで一緒に更新することが多い（例: 新しい落とし穴を見つけたら L1 ルールに追記しつつスキル手順も直す）

「スキルという名前なのに `.claude/skills/` が隠しフォルダで、`rule/` の方が目立つ」という見え方の違和感は、Claude Code / Cursor がスキルを `.claude/skills/` 配下に置くことを要求する仕様に由来するもので、フォルダ構成を変えても解消しません。

## 迷ったらここを見る

数が増えてきたときに探す場所は、フォルダを分けるのではなく **索引ファイル** に寄せています。

| 知りたいこと | 見る場所 |
|---|---|
| どのルールをいつ読むか | [`rule/RULE_INDEX.md`](rule/RULE_INDEX.md) |
| ルールを読む詳しい手順 | [`rule/RULE_ROUTING_PLAYBOOK.md`](rule/RULE_ROUTING_PLAYBOOK.md) |
| どんなスキルがあるか（人間向け） | [`metadata/SKILLS_INDEX.md`](metadata/SKILLS_INDEX.md) |
| スキル台帳（詳細・正本管理） | [`metadata/SKILL_CATALOG.md`](metadata/SKILL_CATALOG.md)（再生成: `managing-skills-yk`） |
| 公開済み図解 HTML の一覧 | [`metadata/surge-published-list.md`](metadata/surge-published-list.md) |

## フォルダの中身

```
yk-skill/
├── .claude/skills/    ← スキル本体（43件・Claude Code/Cursor が自動発見）
├── .cursor/rules/     ← L0 entry（.mdc・glob/alwaysApply でルールへの入口を要約）
├── rule/              ← L1 実務ルール（SSOT・帯フォルダごとに分類。索引は RULE_INDEX.md）
├── metadata/          ← スキル台帳・公開図解台帳
├── sample/            ← スキル作成例（`majiai-diagram`）
├── templates/         ← 独立リポ雛形等
└── output/            ← 生成物の一時置き場
```

## スキルの作り方を学ぶ

`sample/majiai-diagram/.claude/skills/diagram-maji/` に実例があります。`SKILL.md`（全体設計）と `references/`（デザインガイド・用語辞書等）を読むと構造がつかめます。新規スキルの作成手順は `.claude/skills/creating-skills/`。

## 困ったとき

チャットで状況を伝えれば、AI がルール索引・スキル台帳から該当箇所を探します。
