# アクセシビリティ — 横断共通（YK）

**目的:** Web アプリ（React · Next · ui-kit · flowchart chrome）の **WCAG 2.2 Level AA** を、設計・実装・テスト・レビューで共有する**薄い横断 SSOT**。数値の詳細・パレットはドメイン rule へ委譲する。

**索引:** [`../RULE_INDEX.md`](../RULE_INDEX.md) No **24**  
**実施計画:** [`A11Y_ROADMAP.md`](A11Y_ROADMAP.md) No **23**

**関連（重複定義しない）:**

| 領域 | SSOT |
|------|------|
| 実施フェーズ · 工数 · CI 段階 | [`A11Y_ROADMAP.md`](A11Y_ROADMAP.md) No **23** |
| 線の太さ · 色の役割（要約） | [`VISUAL_DESIGN_RULES.md`](VISUAL_DESIGN_RULES.md) No **19** |
| UX ヒューリスティック | [`USABILITY_HEURISTICS_RULES.md`](USABILITY_HEURISTICS_RULES.md) No **20** |
| GAS / surge 静的 HTML（chip · コントラスト表） | [`GAS_REPORT_DESIGN_RULES.md`](../50_gas_html_test/GAS_REPORT_DESIGN_RULES.md) No **52** §6 |
| flowchart 操作 chrome（class SSOT） | `c:/yk-application/flowchart-studio/components/flowchart/flowchartUiClasses.ts` · [`design-system.md`](c:/yk-application/flowchart-studio/docs/design-system.md) レイヤー C |
| shadcn / ui-kit 部品 | [`SHADCN_UI_RULES.md`](../30_web_stack/SHADCN_UI_RULES.md) · `workspace-ui-kit/components/ui/` |
| Playwright · axe · E2E 設計 | [`PLAYWRIGHT_RULES.md`](../50_gas_html_test/PLAYWRIGHT_RULES.md) No **53** · [`a11y.md`](../../.claude/skills/designing-playwright-tests-yk/references/a11y.md) |

**最終更新:** 2026-06-20

---

## 1. 準拠目標と JIS の位置づけ

| 項目 | 内容 |
|------|------|
| **準拠目標** | [WCAG 2.2 Level AA](https://www.w3.org/TR/2023/REC-WCAG22-20231005/) を **設計・レビュー・テストの基準** とする |
| **対象外** | 公的適合宣言 · 第三者監査 · [WCAG 3.0](https://www.w3.org/TR/wcag-3.0/) 準拠（WD · 参照のみ） |
| **JIS 現行** | JIS X 8341-3:2016 ≒ WCAG 2.0 相当。**2026-06 時点で WCAG 2.2 AA 準拠目標と JIS 適合宣言は同一視しない** |
| **JIS 改正（見込み）** | ISO/IEC 40500:2025（WCAG 2.2 一致）に合わせた改正原案が検討中（2026 年度内公示見込み）。chrome 部分の先取りは [`A11Y_ROADMAP.md`](A11Y_ROADMAP.md) Phase 1–4 を参照 |

> **重要:** **axe 合格 ≠ WCAG 2.2 AA 合格。** 自動化は WCAG 問題のおおよそ **30–40%** のみ。§5 チェックリストの **手動項目** を満たして初めて AA 相当と言える。

---

## 2. 適用スコープ（Phase 1）

### 2-1. 含む

| 対象 | 備考 |
|------|------|
| `workspace-ui-kit` 共通 UI | shadcn ベース · diagram-manager 等が恩恵 |
| `flowchart-studio` **操作 chrome** | ツールバー · ナビ · 表 · ダイアログ · 認証バー |
| 新規画面（上記リポジトリ） | §5 チェックリスト全項目 |

### 2-2. Phase 1 やらないこと

| 対象 | 理由 |
|------|------|
| React Flow **キャンバス本体** | Phase 5 で別判断（[`A11Y_ROADMAP.md`](A11Y_ROADMAP.md) §9） |
| surge 静的図解 HTML | No **52** GAS 帯で別管理 |
| GAS レポート HTML の再監査 | 既に No **52** §6 で整備済み |
| 既存画面の一括改修 | §6 運用ルール（触った範囲のみ） |

### 2-3. 誤ルーティング防止

| 作業 | Read | Read しない |
|------|------|-------------|
| React / ui-kit / flowchart chrome | **本ファイル** + ドメイン SSOT | No **52** のみで代替 |
| GAS / surge chip HTML | No **52** §6 | 本ファイルで GAS 色を ui-kit に流用 |

---

## 3. 横断数値（要約）

詳細パレットはドメイン SSOT。ここは **AA の共通閾値** のみ。

| 項目 | WCAG | 値 |
|------|------|-----|
| 通常テキストと背景 | 1.4.3 | **4.5:1** 以上 |
| 大きいテキストと背景 | 1.4.3 | **3:1** 以上（pt 基準 · 実装時はツールで再計測） |
| 非テキスト UI（境界 · アイコン · focus ring） | 1.4.11 | **3:1** 以上 |
| タッチ / ポインタターゲット（最小） | 2.5.8 | **24 × 24 CSS px**（例外あり · §3-1） |
| フォーカス可視性 | 2.4.7 | `:focus-visible` で明示リング · `outline: none` 単独禁止 |

### 3-1. 2.5.8 Target Size の例外

WCAG 2.5.8 には **Spacing · Equivalent · Inline · User agent · Essential** 等の例外がある。24px 未満を許容する場合は **PR または ADR に理由 1 行** を残す。

| 区分 | 内容 |
|------|------|
| **WCAG AA 必須** | 24 × 24 CSS px（例外条件を満たす場合を除く） |
| **推奨（AA 外）** | モバイルで実質 44 × 44 px — Apple HIG 等のプラットフォーム慣行。GAS No **52** §6 の 44px 記述はこの区分 |

---

## 4. 実装原則（MUST）

### 4-1. セマンティクスと ARIA

- ボタンは `<button>`、リンクは `<a href>`、見出しは `<h1>`–`<h6>` を正しく使う
- 装飾画像は `alt=""`、意味のある画像は適切な `alt`
- 状態は `aria-expanded` · `aria-selected` · `aria-current` 等で補完（ロケーターは `getByRole` / `getByLabel` と一致させる）

### 4-2. キーボード

- すべてのインタラクティブ要素に **Tab** で到達できる
- **Enter / Space** で実行可能（ネイティブ `<button>` を優先）
- メニュー · ダイアログは WAI-ARIA APG または shadcn 部品で **Escape · focus trap** を満たす

### 4-3. フォーカス（flowchart chrome）

**SSOT:** `flowchartUiClasses.ts` — インタラクティブ系定数の基底に `fcFocusRing`（または同等）を付与する。

```css
/* 参考: GAS No 52 §6 と同趣旨。flowchart は flow-* 色で 3:1 を再計測 */
:focus-visible {
  outline: 3px solid /* 背景と 3:1 以上 */;
  outline-offset: 2px;
}
```

- shadcn `Button`（ui-kit / flowchart `components/ui/`）は既に `focus-visible:ring-3` あり。**flowchart 実 UI が `fcBtn*` 直書きの間は fc* 側を正とする**

### 4-4. 色だけに依存しない（1.4.1）

- エラー · 状態 · 種別は **色 + テキスト / アイコン / 形状** で識別
- 詳細は No **52** §6（GAS）· flowchart 凡例 · 表の行ハイライトを参照

---

## 5. WCAG 2.2 AA — 新規 Success Criteria チェックリスト

WCAG 2.1 から **追加** された基準。Level AA 相当は **太字**。

| SC | 名称 | Level | 自動 | 手動 / E2E | Phase 1 対象 |
|----|------|-------|------|------------|--------------|
| 3.2.6 | Consistent Help | A | — | レビュー | ヘルプ UI 追加時 |
| 3.3.7 | Redundant Entry | A | 一部 | フォーム設計 | 該当フォーム |
| **2.4.11** | **Focus Not Obscured (Minimum)** | **AA** | **×** | **Tab + 目視 / E2E** | **表 sticky thead · pane header · overlay** |
| **2.5.7** | **Dragging Movements** | **AA** | **×** | **代替操作の有無** | **`panOnDrag` · 将来 DnD** |
| **2.5.8** | **Target Size (Minimum)** | **AA** | 一部（axe `target-size`） | 実測 · compact ボタン | **fc* 全インタラクティブ** |
| **3.3.8** | **Accessible Authentication (Minimum)** | **AA** | 一部 | ログインフロー確認 | Supabase Auth 利用時 |

### 5-1. flowchart 向け適用境界

| UI 領域 | 2.5.7 | 2.4.11 | 備考 |
|---------|-------|--------|------|
| 表エディタ | — | ✓ 優先 | Primary 編集面 |
| ツールバー · メニュー · ナビ | — | ✓ | chrome |
| キャンバス `panOnDrag` | ✓ | — | Phase 5 · キーボード pan / Controls 代替 |
| ノード DnD（将来） | ✓ 必須 | — | 表側並べ替えを先に設計ゲート化 |

---

## 6. 運用ルール

| 区分 | ルール |
|------|--------|
| **新規画面** | §5 チェックリスト + §4 原則の **全項目** |
| **既存画面** | その PR で **変更したコンポーネント配下のみ** 修正 |
| **axe 対象ルート**（[`A11Y_ROADMAP.md`](A11Y_ROADMAP.md) Phase 2 以降） | ルート変更時は **例外なく** 違反解消または SSOT 上の exclude（Issue 番号付き） |

---

## 7. ツールと検証層

### 7-1. 三層パイプライン

| 層 | ツール | タイミング | カバー |
|----|--------|------------|--------|
| **静的** | `eslint-plugin-jsx-a11y`（`eslint-config-next/core-web-vitals` 経由） | 編集 · pre-commit | alt · ARIA 属性 · セマンティクス（**2.2 新基準は非対応**） |
| **E2E 監査** | `@axe-core/playwright` | CI e2e job · 代表画面 1 本 | コントラスト · label · 重複 ID 等 |
| **手動 / キーボード E2E** | Playwright（axe 非依存 spec） | CI · レビュー | focus trap · 2.4.11 · 2.5.7 · メニュー操作 |

pre-commit / pre-push に **axe は載せない**（build + webServer 前提 · [`A11Y_ROADMAP.md`](A11Y_ROADMAP.md) §6）。

### 7-2. axe WCAG タグ（累積指定 · SSOT）

`wcag22aa` **のみ** では 2.0/2.1 由来ルールが漏れる。必ず **6 タグすべて** を指定する。

```typescript
export const WCAG_AXE_TAGS = [
  "wcag2a",
  "wcag2aa",
  "wcag21a",
  "wcag21aa",
  "wcag22a",
  "wcag22aa",
] as const;
```

実装 SSOT（Phase 2 以降）: `flowchart-studio/e2e/helpers/a11y.ts`  
設計 SSOT: [`a11y.md`](../../.claude/skills/designing-playwright-tests-yk/references/a11y.md)

### 7-3. axe 実行タイミング（代表）

| タイミング | 例 |
|------------|-----|
| 初期表示（安定後） | `openPreviewWithSample` 到達後 |
| メニュー展開後 | 「その他」open → `analyze()` |
| ダイアログ open 後 | 確認ダイアログ表示後 |

動的 UI は **操作 → 安定待ち → analyze()**（[`a11y.md`](../../.claude/skills/designing-playwright-tests-yk/references/a11y.md)）。

### 7-4. CI ゲート（参照）

| 段階 | `AXE_GATE` | 詳細 |
|------|------------|------|
| Phase A | `warn` | 違反ログ · artifact · PR は止めない |
| Phase B | `serious` | `critical` / `serious` のみ fail |

[`A11Y_ROADMAP.md`](A11Y_ROADMAP.md) §6–8 が正本。

### 7-5. 手動確認（任意 · アカウント不要）

- Lighthouse（Chrome DevTools）
- WAVE · Axe DevTools 拡張（無料版）
- NVDA（Windows）· VoiceOver（macOS）— 主要フローのスポット確認

---

## 8. エージェント向けチェック（UI を触るターン）

- [ ] スコープは Phase 1 か（キャンバス本体を無理に AA 全項目で直していないか）
- [ ] flowchart chrome は **`flowchartUiClasses.ts` 経由** か（`fcBtn*` 直書きの focus 漏れ）
- [ ] `:focus-visible` が chrome ボタンに付いているか
- [ ] 24px 未満のターゲットに例外理由があるか
- [ ] 2.4.11 · 2.5.7 を axe だけで済ませていないか
- [ ] GAS 色を React chrome に流用していないか（design-system レイヤー分離）

迷ったときは本ファイル → [`A11Y_ROADMAP.md`](A11Y_ROADMAP.md) → ドメイン SSOT の順。

---

## 9. 参照 URL

- [What's New in WCAG 2.2（W3C WAI）](https://www.w3.org/WAI/standards-guidelines/wcag/new-in-22/)
- [Accessibility testing（Playwright）](https://playwright.dev/docs/accessibility-testing)
- [WCAG 2.2 日本語訳（WAIC）](https://waic.jp/translations/WCAG22/)
