# アクセシビリティ導入ロードマップ（YK）

**目的:** YK ワークスペースの Web アプリ開発環境に **WCAG 2.2 Level AA** を段階的に組み込むための実施計画。  
**ステータス:** active（2026-06-20 策定）  
**索引:** [`../RULE_INDEX.md`](../RULE_INDEX.md) No **23**  
**チェックリスト SSOT:** [`A11Y_RULES.md`](A11Y_RULES.md) No **24**

**関連:** [`VISUAL_DESIGN_RULES.md`](VISUAL_DESIGN_RULES.md) No 19 · [`USABILITY_HEURISTICS_RULES.md`](USABILITY_HEURISTICS_RULES.md) No 20 · [`50_gas_html_test/GAS_REPORT_DESIGN_RULES.md`](../50_gas_html_test/GAS_REPORT_DESIGN_RULES.md) No 52 · [`50_gas_html_test/PLAYWRIGHT_RULES.md`](../50_gas_html_test/PLAYWRIGHT_RULES.md) No 53 · [`designing-playwright-tests-yk` references/a11y.md](../../.claude/skills/designing-playwright-tests-yk/references/a11y.md)

**最終更新:** 2026-06-20

---

## 1. 背景と方針

### 1-1. なぜ今

| 事実 | 意味 |
|------|------|
| [WCAG 2.2](https://www.w3.org/TR/2023/REC-WCAG22-20231005/) が W3C Recommendation（2023-10） | 世界標準は 2.2 AA |
| JIS X 8341-3:2016 は WCAG 2.0 相当 | 現行 JIS とは数値・新基準が異なる |
| 改正 JIS（WCAG 2.2 一致規格）が 2026 年度内公示見込み | chrome 部分から先取りすると手戻りが小さい |
| [WCAG 3.0](https://www.w3.org/TR/wcag-3.0/) は Working Draft（完成 2028 以降見込み） | **準拠目標は 2.2 AA を維持**（3.0 は参照のみ） |

### 1-2. 採用方針（改変案 A′）

調査（Web）＋ 4 視点レビュー（SME / PM / UX / SRE）の合意に基づく。

| 項目 | 内容 |
|------|------|
| **準拠目標** | WCAG 2.2 Level AA を **設計・レビュー・テストの基準** とする |
| **対象外** | 公的適合宣言 · 第三者監査 · WCAG 3.0 準拠 |
| **Phase 1 スコープ** | `workspace-ui-kit` 共通 UI ＋ `flowchart-studio` **操作 chrome のみ** |
| **Phase 1 やらないこと** | React Flow キャンバス本体 · surge 静的図解 · GAS レポート再監査 · 既存画面一括改修 |
| **却下した案** | B: GAS ルール拡張のみ · C: axe のみ先行 · D: ui-kit のみ（キャンバス除外は A′ に統合） |

### 1-3. 追加アカウント

**不要。** `eslint-plugin-jsx-a11y` · `@axe-core/playwright` · Playwright · ブラウザ拡張（Lighthouse / WAVE / Axe DevTools 無料版）で足りる。

---

## 2. 現状（2026-06-20）

| 層 | 状態 | 備考 |
|----|------|------|
| GAS 静的 HTML | [`GAS_REPORT_DESIGN_RULES.md`](../50_gas_html_test/GAS_REPORT_DESIGN_RULES.md) §6 に WCAG 2.2 AA 詳細あり | React アプリには自動適用されない |
| flowchart chrome | `flowchartUiClasses.ts` の `fcBtn*` に **focus-visible なし** | shadcn `Button` は存在するが未使用 |
| eslint | `eslint-config-next/core-web-vitals` 経由で jsx-a11y（間接） | 2.2 新基準は非対応 |
| Playwright E2E | 8 spec · 34 test · `getByRole` 中心 | 良好 |
| axe E2E | **未導入** | `@axe-core/playwright` なし |
| 横断 a11y SSOT | **なし** | 本ロードマップ策定時点 |

---

## 3. フェーズ一覧

```
Phase 0  方針 SSOT（A11Y_RULES.md）
   ↓
Phase 1  chrome 修正（ui-kit + flowchartUiClasses）
   ↓
Phase 2  axe 導入（warn-only）
   ↓
Phase 3  手動 E2E（2.2 新基準・axe 非検出分）
   ↓
Phase 4  axe serious fail へ昇格
   ↓
Phase 5  キャンバス（別意思決定）
```

| Phase | 名称 | 主な成果物 | 目安工数 |
|-------|------|------------|----------|
| **0** | 方針 SSOT | `A11Y_RULES.md` · `RULE_INDEX` 追記 · `a11y.md` タグ SSOT 化 | 1〜2 日 |
| **1** | chrome 修正 | `flowchartUiClasses.ts` · 優先コンポーネント群 | 3〜7 日 |
| **2** | axe warn | `@axe-core/playwright` · `e2e/helpers/a11y.ts` · CI artifact | 1〜2 日 |
| **3** | 手動 E2E | `e2e/a11y-keyboard.spec.ts` 等 | 2〜4 日 |
| **4** | axe ゲート昇格 | `AXE_GATE=serious` · burn-down 完了 | 2〜4 週間（並行） |
| **5** | キャンバス | pan 代替 · SR 要約 · DnD 設計ゲート | 未見積（別判断） |

---

## 4. Phase 0 — 方針 SSOT

### 4-1. 作成ファイル

**`10_meta/A11Y_RULES.md`**（薄い横断 SSOT。詳細数値はドメイン rule へ委譲）

必須セクション:

1. 準拠目標と JIS 現行 / 改正原案の位置づけ（見込み表記）
2. Phase 1 対象と **やらないこと**
3. **WCAG 2.2 AA 新 6 基準チェックリスト**（自動 / 手動の区別）
4. ツール限界（axe ≒ 30–40% · jsx-a11y は 2.0/2.1 中心）
5. axe 累積タグ SSOT（下記 §6）
6. ドメイン参照リンク（GAS No 52 · flowchart design-system · ui-kit）

### 4-2. 索引・関連更新

| ファイル | 変更 |
|----------|------|
| `RULE_INDEX.md` | No 23 行（本ロードマップ）· No 24 行（A11Y_RULES 作成後） |
| `VISUAL_DESIGN_RULES.md` §3 | A11Y_RULES へリンク 1 行 |
| `a11y.md` | 累積タグ 6 種を明記 |

### 4-3. 完了条件

- [x] `A11Y_RULES.md` がエージェント・人間の「a11y で何を読むか」の入口になる
- [x] 「axe 合格 ≠ AA 合格」が明文化されている

---

## 5. Phase 1 — chrome 修正

### 5-1. flowchart（最優先）

**SSOT:** `c:/yk-application/flowchart-studio/frontend/src/components/flowchart/flowchartUiClasses.ts`

| Step | 内容 | WCAG |
|------|------|------|
| 1a | `fcFocusRing` 共通クラス追加（`:focus-visible` · outline 3px + offset 2px 等） | 2.4.7 |
| 1b | `fcBtn*` / `fcNav*` / `fcMenu*` / `fcMobileTab*` / `fcAuthBar*` 基底へ適用 | 2.4.7 |
| 1c | compact / 削除ボタンを `min-h-6 min-w-6`（24px）以上 | 2.5.8 |
| 1d | `--a11y-target-min: 24px` 等を CSS 変数化（`globals.css`） | 2.5.8 |

**方針:** shadcn `Button` への全面移行は行わない（差分小の **fc* 拡張** を Phase 1 で採用）。

### 5-2. workspace-ui-kit

- 既存 `focus-visible:ring-3` を維持（新設しない）
- 24px 未満のアイコンボタン等を個別修正
- GAS 色の流用はしない（design-system のレイヤー分離を維持）

### 5-3. Step2 コンポーネント優先順位

| 優先 | コンポーネント | 主な論点 |
|------|----------------|----------|
| **P0** | `FlowTableEditor.tsx` | 2.4.11 sticky thead · 2.5.8 削除ボタン |
| **P0** | `FlowchartEditor.tsx` | ツールバー · モバイル tab · バナー |
| **P1** | `EditorMoreMenu.tsx` | メニュー keyboard（APG または DropdownMenu 化） |
| **P1** | `ModuleNavPane.tsx` | 2.5.8 · tree keyboard |
| **P2** | `CsvPastePanel.tsx` · `FlowCanvas.tsx` | compact · 2.5.7 pan 代替 · キャンバス境界 |
| **P3** | 各 Dialog · `AppAuthBar.tsx` | focus trap · Escape · 2.5.8 |

### 5-4. 完了条件

- [ ] flowchart chrome のインタラクティブ要素に `:focus-visible` が視認できる
- [ ] 24px 未満の既知コントロールがリスト化され、修正または例外理由が記録されている

---

## 6. Phase 2 — axe 導入（warn-only）

### 6-1. 追加パッケージ・ファイル

| 対象 | 内容 |
|------|------|
| `flowchart-studio/package.json` | `@axe-core/playwright`（devDependency） |
| `e2e/helpers/a11y.ts` | AxeBuilder · タグ · gate · exclude SSOT |
| `e2e/manual-check.spec.ts` | 専用 test **1 本**（`openPreviewWithSample` 安定後） |

### 6-2. WCAG タグ（累積指定・SSOT）

```typescript
const WCAG_TAGS = [
  "wcag2a",
  "wcag2aa",
  "wcag21a",
  "wcag21aa",
  "wcag22a",
  "wcag22aa",
] as const;
```

`wcag22aa` のみでは 2.0/2.1 由来ルールが漏れる。

### 6-3. CI ゲート

| 段階 | `AXE_GATE` | 挙動 |
|------|------------|------|
| Phase A（2〜4 週間） | `warn` | 違反ログ + `axe-report.json` artifact · **PR は止めない** |
| Phase B（steady state） | `serious` | `critical` / `serious` のみ fail |

**非推奨:** P4 全 violation fail（初期）· pre-commit / pre-push への axe 載せ · 8 spec 全件 scan

### 6-4. 完了条件

- [ ] CI e2e job で axe 1 本が warn で緑
- [ ] 違反一覧 artifact が PR から参照できる

---

## 7. Phase 3 — 手動 E2E（axe 非検出）

axe では検出できない WCAG 2.2 新基準を **別 spec** でカバーする。

| 基準 | テスト観点 | 対象 UI |
|------|------------|---------|
| **2.4.11** Focus Not Obscured | Tab 移動で focus が sticky 要素に **完全に** 隠れない | 表 thead · pane header · stale overlay |
| **2.5.7** Dragging Movements | ドラッグ操作に単一ポインタ代替 | `panOnDrag` · 将来 DnD |
| **2.1.1** Keyboard | Tab trap · Escape · メニュー Arrow キー | EditorMoreMenu · 確認ダイアログ |

**ファイル案:** `e2e/a11y-keyboard.spec.ts`

### 完了条件

- [ ] 上記 3 論点に対応する E2E が 1 本以上存在
- [ ] `A11Y_RULES.md` チェックリストと spec が対応づいている

---

## 8. Phase 4 — axe ゲート昇格

1. Phase 2 warn 期間中に burn-down（exclude / disableRules は `a11y.ts` に集約 · Issue 番号付き rationale）
2. 重大違反（critical / serious）が安定して減ったら `AXE_GATE=serious` に切替
3. 新規画面は **A11Y_RULES チェックリスト全項目** を満たす（axe はその一部）

### 運用ルール

| 区分 | ルール |
|------|--------|
| **新規画面** | チェックリスト全項目 |
| **既存画面** | その PR で変更したコンポーネント配下のみ修正 |
| **axe 対象ルート** | 変更時は例外なく修正 |

---

## 9. Phase 5 — キャンバス（別意思決定）

Phase 1 では **スコープ外**。着手時に再判断する。

| 領域 | 方針案 |
|------|--------|
| 表エディタ | WCAG 完全適用（Primary UI） |
| キャンバス（プレビュー） | 補助 UI · `role="img"` + 要約 aria-label |
| panOnDrag | 2.5.7 — キーボード pan / Controls で代替 |
| ノード DnD（将来） | 表側の並べ替えボタンを先に設計ゲート化 |

---

## 10. 開発環境の変化（Before / After）

### Before（現状）

```
編集 → lint-staged(eslint/jsx-a11y) → push → CI(lint + E2E 34件)
```

### After（Phase 4 完了時）

```
編集 → lint-staged(eslint) → push → CI(lint + E2E 34件 + axe 1本 + keyboard E2E)
                                      ↑ serious: 重大違反で赤
ローカル任意: npx playwright test e2e/manual-check.spec.ts -g a11y
```

| 変わる | 変わらない |
|--------|------------|
| focus リングの視認性 · 一部ボタンサイズ | pre-commit に axe |
| `A11Y_RULES.md` 参照 | GAS / surge 一括改修 |
| axe artifact · 累積タグ 6 種 | 全 spec axe scan |
| 手動 keyboard E2E 追加 | 有料 SaaS アカウント |

---

## 11. メリット / デメリット（再掲）

### メリット（初期以降）

- chrome の a11y 回帰を PR 前に検知
- 方針迷い・エージェント引き継ぎコストの削減
- `flowchartUiClasses.ts` 修正の全画面波及
- JIS 改正（chrome 部分）への先取り

### デメリット / コスト

- Phase 0–2 の初期工数（数日〜1–2 週間）
- warn 期間の burn-down 作業
- AA 完全達成には手動 E2E が別途必要
- キャンバスは Phase 5 まで未対応

---

## 12. 参照 URL（調査時）

- [What's New in WCAG 2.2（W3C WAI）](https://www.w3.org/WAI/standards-guidelines/wcag/new-in-22/)
- [WCAG 2 Overview（W3C）](https://www.w3.org/WAI/standards-guidelines/wcag/)
- [WCAG 3 Introduction（W3C）](https://www.w3.org/WAI/standards-guidelines/wcag/wcag3-intro/)
- [Accessibility testing（Playwright）](https://playwright.dev/docs/accessibility-testing)
- [Axe-core 4.5 WCAG 2.2 support（Deque）](https://www.deque.com/blog/axe-core-4-5-first-wcag-2-2-support-and-more/)
- [WCAG 2.2 日本語訳更新（WAIC）](https://waic.jp/news/20260608/)
- [2026年 Web アクセシビリティ展望（gihyo）](https://gihyo.jp/article/2026/01/web-accessibility-prospect)

---

## 13. 次のアクション

| 順 | タスク | 担当 |
|----|--------|------|
| 1 | ~~`A11Y_RULES.md` 起草~~（Phase 0） | **完了** |
| 2 | `flowchartUiClasses.ts` focus + 24px（Phase 1a–c） | **次** |
| 3 | `@axe-core/playwright` + warn CI（Phase 2） | Phase 1 P0 完了後 |

**本ファイルの位置づけ:** 実施計画・経緯の SSOT。数値・チェックリストの正本は `A11Y_RULES.md`（Phase 0 で作成）。
