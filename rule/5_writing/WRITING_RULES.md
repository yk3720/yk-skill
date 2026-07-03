# 文章ルール（Slack・ドキュメント）

**目的:** Slack・社内ドキュメント・メール等、**人が書く業務文章**の体裁と論理構成の SSOT。Agent のチャット応答は [`10_meta/COMMUNICATION_RULES.md`](../10_meta/COMMUNICATION_RULES.md)（No 16）を参照。

**ステータス:** active（索引 No 05 と同期）

**詳細（具体例付き）:** [`references/WRITING_RULES_CONTENT.md`](references/WRITING_RULES_CONTENT.md)（1〜17）· [`references/WRITING_RULES_FORMAT.md`](references/WRITING_RULES_FORMAT.md)（18〜34）

**最終更新:** 2026-07-03（L1 / references 分割）

---

## 0. いつ Read するか

| 触るとき | Read |
|----------|------|
| Slack・メール・社内 MD を**書く・直す** | **本ファイル** §1〜§3（要約） |
| 具体例・悪い例/良い例が欲しい | 下表の **references**（該当ルール番号のみ） |
| 提案文・報告書の論理構成 | [`WRITING_RULES_CONTENT.md`](references/WRITING_RULES_CONTENT.md) |
| 改行・リスト・敬語・用語の体裁 | [`WRITING_RULES_FORMAT.md`](references/WRITING_RULES_FORMAT.md) |
| Agent のチャット応答 | No **16** `COMMUNICATION_RULES.md` §2（No 05 精神借用 · 本ファイルと混同しない） |

**原則:** 毎回 L1 の要約で足りる。具体例が必要なときだけ references を Read する。

---

## 1. ひとことで言うと

- 件名と冒頭で**結論を先に**書く。読み手が3秒で内容を判断できる状態を目指す
- 1文は短く、**情報は「■→◎→・」の階層**で整理する
- **事実・解釈・提案を分け**、選択肢を出すときは必ず推奨案を理由つきで示す
- 期限・数値・抽象語は**具体的に**書く（「なるはや」ではなく日時、「効率化」ではなく何をするか）

迷ったら「相手が一度読んだだけで、同じ情景が頭に浮かぶか」を基準に判断してください。

---

## 2. なぜ文章ルールがあるのか

文章を書くことは考えることそのものです。書いて初めて **論理が整い**、**気持ちが整う**。この2つがそろうと正しく決められ、相手に動いてもらえます。

このルールは作法ではなく、考えを整理し相手に最短で届ける技術です。文章を読むのはたいてい自分より忙しい相手 — わかりにくい文章は相手の時間と判断する力を奪います。理想は1行読んだだけで「それでOK」と先に進める状態です。

---

## 3. ルール早見表

| # | ルール | 詳細 |
| :--- | :--- | :--- |
| 1 | 件名と冒頭で要点を明確に伝える | [CONTENT §1](references/WRITING_RULES_CONTENT.md#1-件名と冒頭で要点を明確に伝える) |
| 2 | 「〜について」「〜の件」を使わない | [§2](references/WRITING_RULES_CONTENT.md#2-についての件を使わない) |
| 3 | 文章は短く区切る | [§3](references/WRITING_RULES_CONTENT.md#3-文章は短く区切る) |
| 4 | 長文には概要を添える | [§4](references/WRITING_RULES_CONTENT.md#4-長文には概要を添える) |
| 5 | 情報を階層構造で整理する | [§5](references/WRITING_RULES_CONTENT.md#5-情報を階層構造で整理する) |
| 6 | 箇条書きは漏れなく重複なく（MECE） | [§6](references/WRITING_RULES_CONTENT.md#6-箇条書きは漏れなく重複なくmece) |
| 7 | 期限は日時まで具体的に指定する | [§7](references/WRITING_RULES_CONTENT.md#7-期限は日時まで具体的に指定する) |
| 8 | 自分の意見・推奨を明示する | [§8](references/WRITING_RULES_CONTENT.md#8-自分の意見推奨を明示する) |
| 9 | 事実・解釈・提案を分ける | [§9](references/WRITING_RULES_CONTENT.md#9-事実解釈提案を分ける) |
| 10 | 外部リンクだけに頼らない | [§10](references/WRITING_RULES_CONTENT.md#10-外部リンクだけに頼らない) |
| 11 | 懸念と対策を示す | [§11](references/WRITING_RULES_CONTENT.md#11-懸念と対策を示す) |
| 12 | 選択肢を網羅して推奨案を示す | [§12](references/WRITING_RULES_CONTENT.md#12-選択肢を網羅して推奨案を示す) |
| 13 | 全体から詳細へ書く | [§13](references/WRITING_RULES_CONTENT.md#13-全体から詳細へ書く) |
| 14 | 正しい階層で箇条書きする | [§14](references/WRITING_RULES_CONTENT.md#14-正しい階層で箇条書きする) |
| 15 | 箇条書きの語尾を統一する | [§15](references/WRITING_RULES_CONTENT.md#15-箇条書きの語尾を統一する) |
| 16 | 敬語は簡潔にする | [§16](references/WRITING_RULES_CONTENT.md#16-敬語は簡潔にする) |
| 17 | 抽象的な言葉は定義する | [§17](references/WRITING_RULES_CONTENT.md#17-抽象的な言葉は定義する) |
| 18 | 意味の区切りで改行する | [§18](references/WRITING_RULES_FORMAT.md#18-意味の区切りで改行する) |
| 19 | 短い文章は階層化しない | [§19](references/WRITING_RULES_FORMAT.md#19-短い文章は階層化しない) |
| 20 | 番号リストは順序・手順のみに使う | [§20](references/WRITING_RULES_FORMAT.md#20-番号リストは順序手順のみに使う) |
| 21 | 具体例は引用・コードブロックで示す | [§21](references/WRITING_RULES_FORMAT.md#21-具体例は引用コードブロックで示す) |
| 22 | 対比は構造で表現する | [§22](references/WRITING_RULES_FORMAT.md#22-対比は構造で表現する) |
| 23 | 順接の「が」で文をつなげない | [§23](references/WRITING_RULES_FORMAT.md#23-順接のがで文をつなげない) |
| 24 | 「また」「さらに」を減らす | [§24](references/WRITING_RULES_FORMAT.md#24-またさらにを減らす) |
| 25 | コロンは見出し用途のみで使う | [§25](references/WRITING_RULES_FORMAT.md#25-コロンは見出し用途のみで使う) |
| 26 | 単独の箇条書き記号は使わない | [§26](references/WRITING_RULES_FORMAT.md#26-単独の箇条書き記号は使わない) |
| 27 | 絵文字でビジュアルをわかりやすくする | [§27](references/WRITING_RULES_FORMAT.md#27-絵文字でビジュアルをわかりやすくする) |
| 28 | 同じ階層の箇条書きは抽象度を揃える | [§28](references/WRITING_RULES_FORMAT.md#28-同じ階層の箇条書きは抽象度を揃える) |
| 29 | 同種情報が3つ以上続くなら箇条書きにする | [§29](references/WRITING_RULES_FORMAT.md#29-同種情報が3つ以上続くなら箇条書きにする) |
| 30 | 予定は日時指定で確定表現にする | [§30](references/WRITING_RULES_FORMAT.md#30-予定は日時指定で確定表現にする) |
| 31 | 用語は一貫して使う | [§31](references/WRITING_RULES_FORMAT.md#31-用語は一貫して使う) |
| 32 | 名前は「〜さん」づけと敬語を基本にする | [§32](references/WRITING_RULES_FORMAT.md#32-名前はさんづけと敬語を基本にする) |
| 33 | 「おつかれさまです」等の前置きは省く | [§33](references/WRITING_RULES_FORMAT.md#33-おつかれさまです等の前置きは省く) |
| 34 | 列挙の前に項目数を伝える | [§34](references/WRITING_RULES_FORMAT.md#34-列挙の前に項目数を伝える) |

---

## 4. references 索引

| ファイル | 範囲 | いつ Read |
|----------|------|-----------|
| [`WRITING_RULES_CONTENT.md`](references/WRITING_RULES_CONTENT.md) | ルール 1〜17 | 件名・結論先出し・階層・提案・事実/解釈/提案の分離 |
| [`WRITING_RULES_FORMAT.md`](references/WRITING_RULES_FORMAT.md) | ルール 18〜34 | 改行・リスト・敬語・接続詞・用語統一・Slack 体裁 |

**分割の目安:** 1〜17 は CONTENT。18 以降は FORMAT。
