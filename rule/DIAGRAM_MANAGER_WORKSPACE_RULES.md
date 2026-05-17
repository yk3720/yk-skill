# 図解管理ワークスペース — 開発ルール

## このルールが必要な背景

第4回月次課題「図解管理ワークスペース」（`workspace-ui-kit` 上の `diagram-manager`）は、**見た目の仕上げが今月のスコープ**で、**データ永続化は次フェーズ**とする。対話で決めた **拡張前提構成（A′）** とドメイン命名を、実装・AI 指示の SSOT に固定する。

**企画・画面仕様の SSOT（人間向け詳細）:**  
`c:\yk-memo\00.ai-driven-school\第四回月次課題_自分専用のワークスペース\案1_図解管理ワークスペース.md`  
**実装メモ・モック現状:** 同フォルダの `モックアップ実装メモ.md`

**コードベース:** `c:\yk-skill\workspace-ui-kit`（`app/diagram-manager/`、`components/diagram-manager/`）

**最終更新:** 2026-05-17（`WORKSPACE_RULES.md` へ共通部分を分離）

**必ず先に読む（キット共通）:** [`WORKSPACE_RULES.md`](WORKSPACE_RULES.md)（`npm run dev`・Turbopack・A′ の共通パターン・復旧手順）

**併用するルール:** `WORKSPACE_RULES.md` · `NEXTJS_RULES.md` · `SHADCN_UI_RULES.md` · `TAILWINDCSS_RULES.md` · `DESIGN_RULES.md` · `workspace-ui-kit/CLAUDE.md`

**索引:** [`RULE_INDEX.md`](RULE_INDEX.md)

---

## 1. スコープ（今月やる / やらない）

| 今月やる | 今月やらない |
|----------|----------------|
| 3ペイン UI の仕上げ（種別 → トピック → 一覧 → 詳細 → 開く） | データの永続化（localStorage / DB / ファイル保存） |
| ハードコードまたは mock repository | メモ編集の保存・カード削除の永続化 |
| フィーチャーフラグで将来機能の枠を用意 | 押せるが何もしない UI |

**MVP（発表成立）:** Pane1 種別＋トピック · Pane2 カード一覧 · Pane3 詳細 ＋ URL を開く。  
**MVP＋α:** タグ・検索・メモ閲覧専用表示。  
**オプション:** surge 運用コマンド（teardown / rename コピー）— 必須ではない。

---

## 2. 拡張前提構成（A′）— MUST

**共通パターン:** `WORKSPACE_RULES.md` §3。以下は図解ドメインのパス。

### 2-1. 4 層

| 層 | パス | 役割 |
|----|------|------|
| 機能フラグ | `lib/diagram/features.ts` | ON/OFF の単一スイッチ |
| ドメイン | `lib/diagram/` | Zod・検索・コマンド生成などの純関数 |
| データ | `lib/diagram/repository.ts` | `list()` 等。今月は mock のみ |
| UI | `components/diagram-manager/` | フラグ OFF の機能は**描画しない** |

### 2-2. フラグ既定値（第4回月次課題・発表版）

```ts
export const diagramFeatures = {
  cardDelete: false,
  memoEdit: false,
  surgeCommands: true,
  surgeCommandsCollapsedDefault: true,
} as const;
```

- `cardDelete: false` → 三点メニューは描画しない。`DiagramCardMenu` と `handleDeleteDiagram` はコードに残す。
- `memoEdit: false` → メモは閲覧専用。`MemoField` は `mode: "readonly"`（将来 `"edit"`）。
- **禁止:** フラグ OFF なのに disabled だけの削除ボタンを残す（偽シグナル）。

---

## 3. ドメイン命名 — MUST

| 概念 | 正しい名前 | 避ける名前（モック遺留） |
|------|------------|-------------------------|
| 図解1件 | `Figure` | — |
| ツール種別 | `Category` / `CategoryId` | `Skill` / `SkillId` |
| 大枠トピック | `Topic` / `TopicId`（`data/topics.ts`） | タグの先頭を棚にする運用 |
| 種別一覧定数 | `CATEGORIES`（`as const`） | `SKILLS` |
| データファイル | `data/figures.ts` | 本格時は `mock-data.ts` から移行 or re-export |

`CategoryId` は `(typeof CATEGORIES)[number]["id"]` で導出し、ユニオンと配列の二重定義をしない。

---

## 4. UI・UX — MUST / SHOULD

### 4-1. 3ペインの責務（現行）

1. **Pane1:** ツール種別の **2 階層ツリー**（種別 → トピック `topicId`）。展開中の種別の下に「すべて」＋トピック一覧。`data/topics.ts` が SSOT。
2. **Pane2:** カード一覧・検索・タグフィルター（タグは**補助ファセット**。大枠は Pane1 のトピック）
3. **Pane3:** 詳細確認 →「図解を開く」（新しいタブ）。surge コマンドは下部・**折りたたみ・デフォルト閉**

第5回の4ペイン想定からプレビューペインは廃止（iframe は実用にならない）。**常時 4 列の 4 ペインは採用しない。**

### 4-1b. ツール種別（Category）— スキルとの対応

| `CategoryId` | ラベル | 対応スキル（`yk-skill/.claude/skills`） |
|--------------|--------|----------------------------------------|
| `techmap` | Techmap | `creating-diagram-techmap` |
| `curiositymap` | CuriosityMap | `creating-curiosity-map` |
| `visual-explainer` | Visual Explainer | `creating-visual-explainers`（`diagram-*.surge.sh`） |
| `tool` | ツール | ダッシュボード等（図解スキルではない） |

図解生成スキルでない例: `commenting-visual-explainers`（FB ツール）、`personal-scheduler`（スケジュール公開）。

### 4-2. ラベル・検索

- 日付の UI ラベルは **公開日**（`surge-published-list.md` と一致）。フィールド名は `publishedAt` 推奨。
- 検索対象: **タイトル・タグ・メモ**。正規化は `lib/diagram/search.ts` に集約:

```ts
function normalize(text: string): string {
  return text.normalize("NFKC").trim().toLowerCase();
}
```

### 4-3. 空状態（0件）

- 種別0件とフィルタ結果0件で文言を分岐する。
- 条件0件時は **適用中の種別・トピック・タグ・キーワード** を表示し、リセットで戻せる。

### 4-4. 状態管理（Workspace）

- 種別切り替え時は `selectedTopicId` を `null`、`selectedFigureId` を `null` にリセット。
- トピック切り替え時は `selectedFigureId` を `null` にリセット。Pane2 は `key={categoryId}-${topicId ?? "all"}` で検索・タグもリセット。
- 詳細の解決: `id` と `categoryId` の**両方**で一致（トピック選択中は `topicId` も一致）。
- `Figure` は `topicId` 必須（`data/topics.ts`）。タグは横断検索用として複数のまま。
- `SKILLS.find()!` は使わず `?? CATEGORIES[0]` でフォールバック。

---

## 5. 技術メモ — MUST（図解ドメイン固有）

- **surge ホスト名:** `new URL(url).hostname`。`replace("https://", ...)` で rename 文字列を組まない。
- **コピー状態:** teardown と rename は `useState` を分ける。

**キット共通（dev・Turbopack・復旧）:** → [`WORKSPACE_RULES.md`](WORKSPACE_RULES.md) §4

**ローカル URL 例:** `http://localhost:3000/diagram-manager`（ポートは `npm run dev` の表示に従う）

---

## 6. エージェント向けチェックリスト

`WORKSPACE_RULES.md` §5 のキット横断項目に加え、図解管理では以下を確認:

- [ ] 新機能は `diagramFeatures` にフラグがあるか（または既存フラグで制御しているか）
- [ ] ロジックは `lib/diagram/` にあり、コンポーネントに直書きしていないか
- [ ] 命名は `Figure` / `Category` / `topicId` か
- [ ] 検索は NFKC 正規化か
- [ ] 企画と矛盾する永続化（localStorage 削除など）を今月入れていないか
- [ ] Pane1 が種別→トピックの 2 階層か

---

## 7. 参照 URL・データ

| 説明 | 場所 |
|------|------|
| 公開図解一覧（データ元） | `c:\yk-skill\surge-published-list.md` |
| ローカル HTML 出力 | `c:\yk-memo\output\` |
