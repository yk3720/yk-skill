# ワークスペース — 共通開発ルール

## このルールが必要な背景

`workspace-ui-kit` 上に **複数のワークスペース（ドメイン別 UI）** を載せる。例: 採用管理（`components/workspace/`・4ペイン）、図解管理（`diagram-manager`・3ペイン）、将来の新規ツール。

本ファイルは **キット横断の共通規範** の SSOT。ドメイン固有の画面・命名・データは **`workspaces/` 配下または `*_WORKSPACE_RULES.md`** を参照する。

**リポジトリ:** `c:\yk-tool\workspace-ui-kit`  
**リポジトリ内エントリ:** `workspace-ui-kit/CLAUDE.md`（ADR・スキル・採用雛形の既定）

**最終更新:** 2026-05-17

**併用するルール:** `../30_web_stack/NEXTJS_RULES.md` · `SHADCN_UI_RULES.md` · `TAILWINDCSS_RULES.md` · 各ドメイン固有ルール（下記索引）。**GAS レポート HTML デザインは含めない**（→ `50_gas_html_test/GAS_REPORT_DESIGN_RULES.md`）

**索引:** [`../RULE_INDEX.md`](../RULE_INDEX.md)

---

## 1. 優先順位（エージェント向け）

```text
狭いスコープ > 広いスコープ
順序: 本ファイル (WORKSPACE_RULES) → ドメイン固有ルール → NEXTJS / SHADCN / DESIGN
```

- **ペイン数・レイアウトの具体**は本ファイルで固定しない。各ルートの SSOT（`CLAUDE.md`、ADR、`Workspace.tsx` 系）に従う。
- ドメインルールとスタックルールが矛盾したら、**ドメイン固有ルールが勝つ**（図解作業では `DIAGRAM_MANAGER_WORKSPACE_RULES.md` 等）。

---

## 2. リポジトリ構成 — MUST

| 層 | パターン | 例 |
|----|----------|-----|
| ルート | `app/<route>/page.tsx` | `app/diagram-manager/` |
| UI | `components/<domain>/` | `components/diagram-manager/` |
| ドメイン | `lib/<domain>/` | `lib/diagram/` |
| 共有 UI | `components/ui/` · `components/primitives/` · `components/workspace/` | shadcn・Pane1Toggle 等 |

**禁止:** 他ドメインの `lib/` をコンポーネントに直書きインポートして流用しない（共有は `components/`・`lib/` の明示的な共通モジュールのみ）。

---

## 3. 拡張前提構成（A′）— 共通パターン

**見た目だけ削る。型・純関数・コンポーネント・ハンドラは残す。** 有効化は各ドメインの `features.ts` を `true` にし、`repository` に処理を足す。

| 層 | 役割（ドメインごとにパスを切る） |
|----|----------------------------------|
| 機能フラグ | `lib/<domain>/features.ts` |
| ドメイン | `lib/<domain>/`（Zod・検索・純関数） |
| データ | `lib/<domain>/repository.ts`（今月は mock 可） |
| UI | `components/<domain>/`（フラグ OFF の機能は**描画しない**） |

**禁止:** フラグ OFF なのに disabled だけのボタンを残す（偽シグナル）。

---

## 4. 技術メモ — MUST（キット共通）

- **shadcn Base UI:** カスタムトリガーは `asChild` ではなく `render`。→ `SHADCN_UI_RULES.md` §5
- **Pane1 折りたたみ:** `components/workspace/Pane1Toggle.tsx` を Sidebar 系で再利用可。
- **オフライン build:** Google Fonts 取得で `npm run build` が落ちる環境あり。開発は `npm run dev`、型のみ `npx tsc --noEmit`。

### 4-1. ローカル開発（`npm run dev`）— MUST

| 項目 | ルール |
|------|--------|
| 作業ディレクトリ | **`c:\yk-tool\workspace-ui-kit` のみ**。`yk-memo` 等では `package.json` がなく失敗する |
| 起動コマンド | 通常 `npm run dev`。Turbopack で不調時は `npm run dev:webpack` |
| 確認 URL | ターミナルの `Local: http://localhost:xxxx` に合わせる |
| **`turbopack.root` 禁止** | `next.config.ts` に **`turbopack: { root: __dirname }` 等を書かない**。Next.js 16 の既知バグで CSS の `tailwindcss` 解決が **親ディレクトリ（`C:\yk-skill`）** から行われ、エラー再試行で **RAM 膨張・PC フリーズ** の原因になる（[#90307](https://github.com/vercel/next.js/issues/90307)、[#92978](https://github.com/vercel/next.js/issues/92978)） |
| `outputFileTracingRoot` | 本番トレース用。`turbopack.root` とは別。プロジェクトルート指定は可 |

### 4-2. フリーズ・クラッシュ時の復旧手順

**症状の例:** `Can't resolve 'tailwindcss' in 'C:\yk-skill'`、Node のメモリ急増、画面操作不能、Cursor が `crashed`（`-2147483645`）で落ちる。

1. タスクマネージャーで **Node（next-server）を終了**、または dev ターミナルで **Ctrl+C**
2. `workspace-ui-kit` で **`.next` フォルダを削除**
3. **`npm run dev`** を再実行（改善しなければ **`npm run dev:webpack`**）
4. ブラウザは **Cursor 外**（Chrome / Edge）で開き、初回コンパイルは **1〜2 分待つ**
5. それでも再発する場合: 親フォルダに **余計な `package-lock.json`**（`package.json` なし）がないか確認

**エージェント向け:** 上記症状時に `turbopack.root` を追加する提案は**しない**。

---

## 5. エージェント向けチェックリスト（キット横断）

実装・変更前に確認:

- [ ] 作業ディレクトリは `workspace-ui-kit` か
- [ ] `next.config.ts` に `turbopack.root` を足していないか
- [ ] ロジックは `lib/<domain>/` にあり、UI に直書きしていないか
- [ ] フラグ OFF の UI を「見た目だけ」残していないか
- [ ] ドメイン固有ルール（図解なら `DIAGRAM_MANAGER_WORKSPACE_RULES.md`）を読んだか

---

## 6. ドメイン固有ルールへのリンク

| ワークスペース | ルールファイル | ルート例 |
|----------------|----------------|----------|
| 図解管理 | `DIAGRAM_MANAGER_WORKSPACE_RULES.md` | `/diagram-manager` |
| 採用管理（雛形） | `workspace-ui-kit/CLAUDE.md` + ADR | `/`（既定） |

将来ドメインを増やすときは `workspaces/<name>.md` への移行を検討（`RULE_INDEX.md` 参照）。
