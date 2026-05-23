# Mermaid 開発ルール（ひな形 v0）
## YK Mermaid 図解・フロー設計 — Design & Development Rules

**ステータス:** `active`（[`RULE_INDEX.md`](../RULE_INDEX.md) Status 列 · PROGRESSIVE L0/L1/L2 整備済）— **本ファイルの構文・安全 MUST は `.mmd` 編集時に適用する**。

**SSOT（本ファイル）:** `yk-skill/rule/45_mermaid/MERMAID_RULES.md`  
**実行手順・ゲート:** `.claude/skills/creating-mermaid-yk/SKILL.md`  
**ロード規則 SSOT:** `.../creating-mermaid-yk/references/ROUTER.md`

**関連ツール（別方式・併用可）**

| 方式 | 場所 | 用途 |
|------|------|------|
| **Mermaid DSL（本ルール）** | `.mmd` / Markdown フェンス | テキストで図を版管理・レビュー |
| **表駆動フロー** | [`c:/yk-tool/flowchart-web/`](c:/yk-tool/flowchart-web/README.md) | JSON/表 → React Flow（**Mermaid 出力は Phase 外**） |
| **Python フローチャート** | `c:/1.cursor/5.Python/`（MZ 系） | デスクトップ・業務ツール（別ドメイン → `40_python/PYTHON_RULES.md`） |

**横断:** [`../10_meta/SECRETS_HYGIENE_RULES.md`](../10_meta/SECRETS_HYGIENE_RULES.md) · [`../10_meta/GIT_WORKFLOW_RULES.md`](../10_meta/GIT_WORKFLOW_RULES.md) · [`../10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md`](../10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md)

**L0 入口:** `yk-skill` · `yk-memo` の `.cursor/rules/mermaid-dev-entry.mdc`（glob `**/*.mmd`）

**最終更新:** 2026-05-23（P11: flowchart-web 横断リンク）  
**索引:** [`../RULE_INDEX.md`](../RULE_INDEX.md)

---

## 0. エージェント向け — いつ何を読むか

| 段階 | 読むもの | タイミング |
|------|----------|------------|
| L0 | `mermaid-dev-entry.mdc` | `**/*.mmd` 編集時に自動適用（入口） |
| L1 | **本ファイル** | Mermaid ソース（`.mmd`）を触るたび・最初 |
| L2 | `creating-mermaid-yk/SKILL.md` | `.mmd` を触る手順・ゲート |
| L2.5 | **Ref Plan** | **図ソース編集前・必須**（テンプレは ROUTER §7） |
| L3 | ROUTER で列挙した公式ページ等のみ | Ref Plan 後 |

**禁止:** 公式ページの無差別 Read · ROUTER/SKILL にないファイルの推測 Read。

**手順:** ROUTER で tier/tag → **Write/StrReplace 前に Ref Plan** → 本ファイル §2〜§8 → §7 ゲート。

**Ref Plan 不要:** 質問のみ・Read のみ。

**tier / tag:** → `creating-mermaid-yk/references/ROUTER.md` §2〜§4（本ファイルに表を置かない）

---

## 1. 四大精神（要約 — Python ルールと同型）

1. **積層的必然** — 図の段階（概要 → 詳細 → 配布用）ごとに成果物を完成形として残し、後から全書き換えしない。
2. **仕様先行** — 図が表すプロセス・境界・責務は、短文仕様または ADR に先立って固定する。Mermaid はその鏡。
3. **論理的生存・可読性** — 孤立ノード・意味不明な ID・ラベル欠落を残さない。エラーはサイレントに握りつぶさない。
4. **工数削減・環境浄化** — `TODO:` 図・使わない subgraph・重複定義を残さない。検証コマンドを決めて繰り返す。

### 1.5 方式選択（図モダリティ — YK 横断 SSOT）

**逆リンク:** [`c:/yk-tool/flowchart-web/README.md`](c:/yk-tool/flowchart-web/README.md) §図モダリティ

| やりたいこと | 選ぶもの | SSOT · 入口 |
|--------------|----------|-------------|
| 表・CSV 貼り付け · ブラウザで編集 · 自動レイアウト · PNG/SVG 即出力 | **flowchart-web** | [`flowchart-web/README.md`](c:/yk-tool/flowchart-web/README.md) · 表 JSON · React Flow |
| テキストで版管理 · Git diff · MD/ADR 埋め込み · レビュー可能な DSL | **Mermaid DSL（本ルール）** | 本ファイル · `.mmd` · `creating-mermaid-yk` · `mermaid-dev-entry.mdc` |
| デスクトップ業務ツール · Excel 連携 · MZ 系 GUI | **Python** | [`40_python/PYTHON_RULES.md`](../40_python/PYTHON_RULES.md) |

**迷ったとき（3 問）**

1. **正本は表（行・列）か、テキスト（`.mmd`）か** — 表なら flowchart-web、テキストなら Mermaid
2. **Mermaid から flowchart-web へエクスポートが必要か** — **現状 No**（flowchart-web は Mermaid 出力 Phase 外）。必要なら表を手で作り直すか、`.mmd` のまま運用
3. **surge 図解 HTML か** — 別系統（`creating-visual-explainers` 等）。本節の Mermaid は **diagram-as-code** のみ

**併用:** 同一プロジェクトで「概要は `.mmd`」「実務フロー編集は flowchart-web」は可。**同一ノードを二重 SSOT にしない**（どちらが正かを README か ADR に 1 行で固定）。

**エージェント:** `.mmd` を触る → 本ルール + `creating-mermaid-yk`。`yk-tool/flowchart-web` 配下を触る → flowchart-web README（本ルールは方式境界の参照のみ）。

---

## 2. 標準プロジェクト構成（Mermaid-as-code）

```
project_or_feature/
├── 仕様・管理/              # 図の目的・対象読者・更新履歴（短文で可）
├── diagrams/
│   ├── overview.mmd         # 全体像（1 ファイル 1 主題）
│   ├── detail-<name>.mmd    # 詳細は分割
│   └── README.md            # 図一覧・読み順・プレビュー手順
├── docs/                    # 図を埋め込む Markdown（任意）
├── mermaid.config.json      # CLI / レンダラ共通設定（任意）
└── package.json             # @mermaid-js/mermaid-cli 等（検証用）
```

| 項目 | 規則 |
|------|------|
| 1 ファイル 1 主題 | 複数の無関係な図を 1 `.mmd` に詰めない |
| 行数目安 | **1 ファイル 200 行以内**（超える前に subgraph 分割 or ファイル分割） |
| 文字数上限 | 公式 **50,000 文字/定義** 以内（超過は必ず分割） |
| ID 命名 | 英数字・キャメル/スネークをプロジェクトで統一。表示ラベルは `[日本語可]` |
| 埋め込み | Markdown は ` ```mermaid ` フェンス。リポジトリ正本は `.mmd` を推奨 |

**シナリオ（どれか 1 つを選び、不要な行は省略可）**

| シナリオ | 必須 | 省略可 |
|----------|------|--------|
| 新規 `diagrams/` プロジェクト | §2 ツリー全体 · `package.json`（mmdc） | `docs/` |
| 既存 `.mmd` 1 ファイル修正 | 当該ファイル · §3 構文 | 新規 `diagrams/README` |
| MD 内フェンスのみ | 当該 MD · フェンス内がパース可能 | `package.json` |

---

## 3. 構文・記法 — MUST

| 項目 | 規則 |
|------|------|
| 宣言 | **frontmatter なし:** 先頭行は図種宣言（`flowchart TD` 等）。**frontmatter あり:** 1 行目は `---` のみ → 閉じ `---` の**次行**が図種宣言 |
| フローチャート | 新規は **`flowchart`** を推奨（`graph` は互換エイリアス・既存維持可） |
| 方向 | 既定は **`flowchart TD`**（縦）。横長の業務フローのみ `LR` |
| 設定 | **`%%{init:...}%%` ディレクティブは新規禁止** → **YAML frontmatter**（`---` で囲む） |
| frontmatter | 先頭行は **`---` のみ**。設定は **`config:` 配下**（例: `config:\n  theme: forest`）。インデント・キーは **case-sensitive** |
| コメント | `%%` 行コメント。コメント内に **`%%{` や `}%%`・`{}` を含めない** |
| 予約語 | ラベルに **`end`** を裸で書かない → **`"end"`** でクォート、または **`End` / `END`** に大文字化 |
| ネスト | ノード内ノードはクォートでエスケープ。過度なネストは分割で解消 |
| エッジ | クロスモジュールは **ノード ID** で接続。**推奨:** subgraph ID を端点にしない（レイアウト・rank エラーの原因になりうる） |
| subgraph | **モジュール・レイヤ単位**で命名。外とつながるノードがある subgraph は **親の direction を継承**することを前提にレイアウトする |

**構文エラー時:** 報告行の **1 つ上** も確認する（公式・コミュニティでよく知られる挙動）。

---

## 4. 図種の選び方（プログラミング用途）

| やりたいこと | 図種 | 備考 |
|--------------|------|------|
| 処理・分岐・業務フロー | `flowchart` | まずこれ。複雑なら subgraph で層分け |
| API・モジュール間の呼び出し | `sequenceDiagram` | 参加者は `participant` で別名を付ける |
| データ構造・永続化 | `erDiagram` | テーブル名・関係を SSOT に合わせる |
| 状態機械 | `stateDiagram-v2` | イベント名は仕様用語と一致 |
| スケジュール | `gantt` | 日付形式をプロジェクトで固定 |
| クラス・型関係 | `classDiagram` | 実験的機能に注意 — バージョンを README に記載 |

**原則:** 1 リリースで **図種を混在させないファイル** を増やさない（必要ならファイルを分ける）。

---

## 5. セキュリティ — MUST（Web レンダリング時）

| 項目 | 規則 |
|------|------|
| 設定場所 | **`securityLevel` は `mermaid.initialize()` / ホスト設定のみ**（`.mmd` の frontmatter や directive では変更できない） |
| 既定 | ホスト側で **`securityLevel: 'strict'`**（HTML タグはエンコード・click 無効） |
| 非信頼入力 | **`strict` または `sandbox`**。`secure: ['securityLevel', ...]` で図からの上書きを防ぐ（[Configuration](https://mermaid.js.org/config/configuration.html)） |
| 緩和 | `loose` / `antiscript` は **信頼できる自社ソースのみ**。公開サイト・他者入力では **禁止** |
| インタラクション | 公開・他者入力の図に **`click` / `call` / 任意 JS コールバック**を書かない |
| サニタイズ | **レンダリング後の DOMPurify だけに依存しない**（ラベル内 HTML は描画時に実行されうる） |
| 外部 URL | ノード画像 `img:`・外部スクリプトは **SSoT リスト外は禁止**（追跡用に台帳化） |
| 機密 | 本番ホスト名・顧客名・トークンをラベルに書かない → [`SECRETS_HYGIENE_RULES.md`](../10_meta/SECRETS_HYGIENE_RULES.md) |

---

## 6. SDD 開発フロー（Spec-Driven Diagram）

| Step | 内容 |
|------|------|
| 0 | 本ルール + SKILL + ROUTER（Ref Plan → ROUTER §7） |
| 0.1 | **Ref Plan** 出力（**Write/StrReplace するターンのみ**。未出力なら `.mmd` を編集しない） |
| 1 | 目的・読者・成功条件（「この図で何が決まるか」）を短文で固定 |
| 2 | 図種・方向・分割方針。既存図との **ID 衝突** を確認 |
| 3 | 実装（新規: 骨格 5 ノード → 分岐追加 → スタイル最後） |
| 4 | 品質ゲート（§7） |
| 5 | SSoT 監査（同じ概念が二重の subgraph / 別ファイルにないか） |
| 6 | 完了報告（§8 tier） |

---

## 7. 品質ゲート（最小チェックリスト）

完了前に確認する。

- [ ] 図種宣言・方向が正しい位置にある（frontmatter 使用時は `---` の次行）
- [ ] **パース成功**（優先: リポに mmdc あり → 下記コマンド / なし → [Mermaid Live Editor](https://mermaid.live/) で確認 / CI のみ → `mermaid.parse`）
- [ ] 孤立ノード・到達不能ノードがない（意図的ならコメントで理由）
- [ ] ラベルに `end` 裸文字・HTML 断片がない
- [ ] 200 行 / 50k 文字以内（超える場合は分割済み）
- [ ] `TODO:` / `FIXME:` を残していない
- [ ] セキュリティ: 公開レンダラで `strict` 相当であること（または理由を明記）

**推奨コマンド（ローカル検証 — ユーザー明示 test 時または CI）**

```bash
npx -p @mermaid-js/mermaid-cli mmdc -i diagrams/overview.mmd -o diagrams/_out/overview.svg
```

**エージェント:** Agent Shell 規律で Shell 禁止のターンは Live Editor 確認結果を完了報告に 1 行書く（`AGENT_SHELL_RULES.md`）。

Linux CI で Chromium が落ちる場合は `puppeteer-config.json` で `--no-sandbox`（**本番デプロイと分離**して管理）。

---

## 8. 完了報告（tier）— Python ルールと同型

| tier | いつ | 末尾に含めるもの |
|------|------|------------------|
| **Light** | 1 ファイル・ラベル修正程度 | **変更概要** · **検証手順（1行）** · **読んだ refs**（例: `MERMAID_RULES.md` L1） |
| **Standard** | 新規図・分岐追加・複数ファイル | 変更概要 · 影響範囲 · SSoT 確認 · 検証コマンド · **読んだ refs** |
| **Full** | 新規プロジェクト・公開パイプライン | Standard + 図一覧 · セキュリティ設定 · バージョン pin |

---

## 9. Ref Plan

**SSOT:** `c:/yk-skill/.claude/skills/creating-mermaid-yk/references/ROUTER.md` §7（テンプレ）· §2〜§4（tier / tag）。

本節に表を戻さない（`PROGRESSIVE_CONTEXT_ROUTING_RULES.md` §5）。

---

## 10. Git・リビジョン運用

| 対象 | 方針 |
|------|------|
| **yk-skill（本ルール）** | Git が SSoT。`draft` → `active` は [`RULE_INDEX.md`](../RULE_INDEX.md) Status 列の昇格目安に従い人間が索引を更新 |
| **図の実体** | 図を置くリポジトリ（`yk-tool` / `yk-memo` / 製品リポ）の Git で管理。バイナリ PNG より **`.mmd` ソースを正**とする |
| **rev 積層** | Python KB と同様、`*revNNN*` 付きアーカイブは **上書き禁止**（別ワークスペース規律がある場合はそちらが優先） |

---

## 11. 既知の落とし穴（調査メモ — 追記用）

| 現象 | 対策 |
|------|------|
| エラー行がずれる | 直前行の括弧・クォート・`end` を確認 |
| subgraph の向きがおかしい | 外へのエッジがあると **親 direction を継承** — レイアウトを組み替える |
| `Cannot set properties of undefined (setting 'rank')` | subgraph 内の **孤立ノード**・**subgraph を端点にしたエッジ**・不適切なクォートを疑う |
| パラメータが効かない | タイポは **黙って無視**される — frontmatter を Live Editor で確認 |
| XSS | `strict` + 入力源の信頼境界。詳細は §5 |
| Cursor Agent で `npx mmdc` が `EPERM` / spawn 失敗 | サンドボックス制限 — **`all` 権限で再実行** または [Live Editor](https://mermaid.live/) で代替確認（2026-05-23 初回試作） |

**運用:** 実装で新しい落とし穴を見つけたら **§11 に 1 行追加**（L1）。詳細化は将来 `references/` へ。

---

## 12. 変更時のルール

- ロード規則を変えるときは将来 **`references/ROUTER.md` のみ**更新（本ファイル §9 に表を戻さない）。
- 構文の MUST を変えるときは **調査 URL を §11 かコミットメッセージに残す**。
- スキル拡張時は `creating-pythoncode-yk` を参照実装とする。
- **実装フィードバック:** ユーザーと「再現手順・期待・実際」を 3 行で記録してから §3 / §7 / §11 を更新する。

---

## 参照 URL（調査 2026-05-23）

- [Diagram Syntax | Mermaid](https://mermaid.js.org/intro/syntax-reference.html) — 構文構造・diagram breakers
- [Flowchart | Mermaid](https://mermaid.js.org/syntax/flowchart.html) — subgraph・direction
- [Configuration / usage](https://mermaid.js.org/config/usage.html) — `mermaid.parse` · `securityLevel` · `mermaid.run`
- [Directives（非推奨）](https://mermaid.js.org/config/directives.html) — frontmatter へ移行
- [@mermaid-js/mermaid-cli](https://github.com/mermaid-js/mermaid-cli) — `mmdc` 検証
- [Mermaid Live Editor](https://mermaid.live/) — 手動プレビュー
