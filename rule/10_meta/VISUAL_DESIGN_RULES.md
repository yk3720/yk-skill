# ビジュアルデザイン — 横断共通（YK）

**目的:** UI・図解・チャートなど、**すべてのプロジェクト**で共有する視覚の基本ルール。ドメイン別の詳細（GAS レポート chip · flowchart 表駆動等）は各 `*_RULES.md` が本ファイルを参照して拡張する。

**索引:** [`../RULE_INDEX.md`](../RULE_INDEX.md) No **19**  
**L0 入口:** `c:/yk-skill/.cursor/rules/visual-design-yk.mdc`（`alwaysApply`）· 同期: `c:/yk-memo/.cursor/rules/`

**関連:** [`COMMUNICATION_RULES.md`](COMMUNICATION_RULES.md) · [`USABILITY_HEURISTICS_RULES.md`](USABILITY_HEURISTICS_RULES.md) No **20**（UX · 文言・画面設計）· [`50_gas_html_test/GAS_REPORT_DESIGN_RULES.md`](../50_gas_html_test/GAS_REPORT_DESIGN_RULES.md)（静的 HTML の Repetition）· [`35_reactflow/references/REACTFLOW_UX_CHROME.md`](../35_reactflow/references/REACTFLOW_UX_CHROME.md) §5.6-3（flowchart 定数）

**最終更新:** 2026-06-25

---

## 1. 適用範囲

| 含む | 含まない（別 SSOT） |
|------|---------------------|
| Web アプリ（React · Next · GAS HTML） | チャット応答の文体（→ No 16） |
| フローチャート · ダイアグラム · 図解 HTML | 図解の**形式**選定（→ `routing-diagram-yk`） |
| 印刷・PDF 向けレイアウト | ブランドカラーの正式定義（プロジェクトごとに可） |

---

## 2. 線の太さ — 基本ルール（MUST）

**原則:** 同一画面・同一図の中で、**枠線・ストローク・区切り線の太さは基本として統一**し、統一感を出す。

| 項目 | 規則 |
|------|------|
| **既定** | 1 つの基準値（例: **2px**）を決め、ノード枠・図形枠・主要な `border` / `stroke-width` に揃える |
| **実装** | マジックナンバーを散在させない。`flowColors.ts` の `FLOW_NODE_FRAME_WIDTH`、CSS 変数 `--stroke-default`、テーマ定数など **1 か所の SSOT** から参照する |
| **単位** | CSS は `px` で明示。SVG は `strokeWidth` と CSS を混在させるときは **見た目が同じになるよう**揃える（`clip-path` 菱形など border が効かない形は SVG stroke 等で代替） |
| **知覚補正** | 数値を同じ 2px にしても菱形の斜線は太く見えやすい → **定数を分けてよい**（例: `FLOW_NODE_FRAME_WIDTH=2` · `FLOW_NODE_DIAMOND_STROKE_WIDTH=1.5`）· 理由をコメントに残す |

### 2-1. 例外（強調）

**強調したい要素**（警告・選択中・エラー・「ここだけ目立たせる」）は、太さ・色・コントラストを変えてよい。これは基本ルールの**上書き**であり、画面全体をバラバラにする理由にはしない。

| 例 | 許容 |
|----|------|
| stale プレビューの琥珀色リング | 意図的な強調 |
| 判断ノードだけ 4px | **×**（形状差で足りる。太さだけ判断特権にしない） |
| エッジ（矢印）とノード枠 | **役割が違う**なら色・太さを分けてもよいが、**ノード同士・枠同士**は揃える |

---

## 3. 色・コントラスト（要約）

- **色の役割分担**はプロジェクトで定義してよい（例: 矢印=青 · 枠=スレート/黒）。
- **大面積の surface（サイドバー・ナビ・ペイン背景）** はニュートラルにし、**彩度の高い brand / accent 色はプライマリ CTA と小面積の選択・リンク**に寄せる。CTA と図形・矢印がすでに同色 family のとき、ナビ大面積に同系統の chromatic 色を載せない（階層競合 · hue pollution）。
- **色だけに意味を頼らない**（色覚多様性 · ラベル併記）— 詳細はドメイン rule（GAS レポート · 企画の色列 B 等）。
- **WCAG 2.2 AA · a11y チェックリスト** — [`A11Y_RULES.md`](A11Y_RULES.md) No **24**（コントラスト数値 · focus · タッチターゲット）。
- 本ファイルは**色のパレット SSOT ではない**。太さの横断ルールが主。flowchart の操作 chrome 詳細は [`design-system.md`](c:/yk-application/flowchart-studio/docs/design-system.md) レイヤー C。

---

## 4. ドメイン別の参照（重複定義しない）

| プロジェクト / 帯 | 拡張 SSOT | 本ルールとの関係 |
|-------------------|-----------|------------------|
| flowchart-studio | `visual/flowColors.ts`（キャンバス）· [`docs/design-system.md`](c:/yk-application/flowchart-studio/docs/design-system.md)（操作 chrome）· REACTFLOW `references/REACTFLOW_UX_CHROME` §5.6-2a · §5.6-3 | ノード枠 `FLOW_NODE_FRAME_WIDTH`（既定 2px） |
| GAS 進捗 · surge 図解 chip | GAS_REPORT_DESIGN | padding · バッジ形状等。線幅は **§2 に合わせる** |
| shadcn / Tailwind UI | SHADCN · TAILWIND | `border-2` 等を選ぶとき **§2 を優先** |

新規 UI を作るときは、実装前に「画面内の既定ストロークは何 px か」を 1 行決め、定数化する。

---

## 5. エージェント向けチェック（UI を触るターン）

- [ ] 同種の枠（ボタン枠・カード・図形ノード）の太さが **1 値に寄せているか**
- [ ] 菱形・`clip-path` 図形で **CSS `border` だけ**に頼っていないか
- [ ] 強調以外で **判断だけ太い**などの例外が増えていないか

迷ったときは本ファイル（L1）を Read。flowchart 実装中は REACTFLOW §5.6 索引 + 該当 `references/` も併読。
