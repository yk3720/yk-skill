# 図解管理ワークスペース — 開発ルール

## このルールが必要な背景

第4回月次課題「図解管理ワークスペース」（`workspace-ui-kit` 上の `diagram-manager`）は、**見た目の仕上げが今月のスコープ**で、**データ永続化は次フェーズ**とする。対話で決めた **拡張前提構成（A′）** とドメイン命名を、実装・AI 指示の SSOT に固定する。

**企画・画面仕様の SSOT（人間向け詳細）:**  
`c:\yk-memo\00.ai-driven-school\第四回月次課題_自分専用のワークスペース\案1_図解管理ワークスペース.md`  
**実装メモ・モック現状:** 同フォルダの `モックアップ実装メモ.md`  
**シリーズグループ（同一題材の別版・横断表示）:** 同フォルダの `図解シリーズグループ設計メモ.md`（**コード未実装時は UI を出さない**）

**コードベース:** `c:\yk-tool\workspace-ui-kit`（`app/diagram-manager/`、`components/diagram-manager/`）

**最終更新:** 2026-05-17（シリーズグループ仕様 §4-5・§3 追記）

**必ず先に読む（キット共通）:** [`WORKSPACE_RULES.md`](WORKSPACE_RULES.md)（`npm run dev`・Turbopack・A′ の共通パターン・復旧手順）

**併用するルール:** `WORKSPACE_RULES.md` · `../30_web_stack/NEXTJS_RULES.md` · `SHADCN_UI_RULES.md` · `TAILWINDCSS_RULES.md` · `workspace-ui-kit/CLAUDE.md`（**`GAS_REPORT_DESIGN` は ui-kit では読まない**）

**索引:** [`../RULE_INDEX.md`](../RULE_INDEX.md)

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
| 題材グループ（横断） | `seriesId`（任意・文字列） | タグ `series:xxx` のみに頼る運用 |
| 向け（任意） | `audience`: `"technical"` \| `"general"` | `seriesId` に向けを埋め込む |
| 種別一覧定数 | `CATEGORIES`（`as const`） | `SKILLS` |
| データファイル | `data/figures.ts` | 本格時は `mock-data.ts` から移行 or re-export |

`CategoryId` は `(typeof CATEGORIES)[number]["id"]` で導出し、ユニオンと配列の二重定義をしない。

---

## 4. UI・UX — MUST / SHOULD

### 4-1. 3ペインの責務（現行）

1. **Pane1:** ツール種別の **2 階層ツリー**（種別 → トピック `topicId`）。展開中の種別の下に「すべて」＋トピック一覧。`data/topics.ts` が SSOT。
2. **Pane2:** カード一覧・検索・タグフィルター（タグは**補助ファセット**。大枠は Pane1 のトピック）。**シリーズグループ実装時**は上段＋下段の2段（→ §4-5）。
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

- 日付の UI ラベルは **公開日**（`metadata/surge-published-list.md` と一致）。フィールド名は `publishedAt` 推奨。
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
- **詳細の解決（上段カード）:** `id` と `categoryId` の**両方**で一致（トピック選択中は `topicId` も一致）。
- **詳細の解決（Pane2 下段・シリーズ兄弟）:** `selectedFigureId` のみで `FIGURES` から1件取得。サイドバーの種別は**切り替えない**（§4-5）。
- `Figure` は `topicId` 必須（`data/topics.ts`）。`seriesId` / `audience` は任意。タグは横断検索用として複数のまま。
- `SKILLS.find()!` は使わず `?? CATEGORIES[0]` でフォールバック。

### 4-5. シリーズグループ（同一題材の別版）— 実装時 MUST

**詳細仕様:** `図解シリーズグループ設計メモ.md`（SSOT）。以下は実装時の要約。

**Pane2**

- **上段:** Pane1 の `categoryId`（＋`topicId`）で絞ったカード。検索・タグは**上段のみ**。
- **下段「同じ題材の他バージョン」:** 上段のいずれかと同じ `seriesId` を持つ Figure。上段に出ている `id` は**含めない**。検索・タグは**適用しない**。表示は**縦積み**。兄弟0件なら下段ごと非表示。
- 下段カード: **種別バッジ常時**、`audience` があれば向けラベル。

**件数**

- Pane1 バッジ・Pane2 フッタは**上段の実件数のみ**（下段はカウントしない）。

**Pane3**

- 下段クリック時は **id のみ**で Figure を表示（種別不一致でも Pane3 を空にしない）。
- 兄弟一覧は任意だが推奨（設計メモ §5-2）。

**データ**

- `seriesId` はグループ内で同一・グループ間で被らない運用。件数上限なし。
- 近いテーマだけでは付けない（設計メモ §6-5）。

**フラグ（任意）**

- 半端な UI を避けるなら `diagramFeatures.seriesRelatedPane` を用意し、実装完了まで `false` でもよい。`seriesId` 付きデータが無いときは下段を描画しない。

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
- [ ] シリーズ実装時: 下段は検索・タグ独立・上段 id と二重表示しないか
- [ ] シリーズ実装時: 下段クリックで Pane3 が id のみ解決か

---

## 7. 参照 URL・データ

| 説明 | 場所 |
|------|------|
| 公開図解一覧（台帳 SSOT） | `c:\yk-skill\metadata\surge-published-list.md` |
| 図解管理 UI シード（台帳 + UI 拡張） | `workspace-ui-kit/data/figures.ts` — `url` · `title` · `publishedAt` · `categoryId` は台帳と一致させる。`topicId` · `tags` · `memo` · `seriesId` は本ファイルのみ |
| ローカル HTML 正本 | **目標** `c:\yk-tool\publish\` · **現（未移行）** `c:\yk-memo\output\` |

**新規公開後の同期:** 図解スキルが台帳を更新したら、`figures.ts` に 1 行追加（または既存行を修正）し、台帳 # 順に並べる。自動読込は未実装（将来 `yk-tool` 移行時に検討）。
