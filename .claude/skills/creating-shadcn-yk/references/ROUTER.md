# shadcn/ui 参照ルーティング（ROUTER）

**SSOT:** 本ファイルが tier · tag · Ref Plan テンプレの唯一の正本。  
**要約・MUST:** `yk-skill/rule/30_web_stack/SHADCN_UI_RULES.md` · **手順:** `../SKILL.md`  
**設計パターン:** `yk-skill/rule/10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md`

**最終更新:** 2026-05-24

---

## 0. 禁止・原則

- `SHADCN_UI_RULES.md` を毎ターン全文 Read する必要はないが、**`components/ui` を Write/StrReplace するターンでは L1 を Read 済み**であること
- **§2 分岐未確定のまま init/add しない**（flowchart=radix · ui-kit=Base · surge=禁止）
- tier / tag 表を `SKILL.md` や L1 に **複製しない**
- **Hooks · Rules of React** → `REACT_RULES` · `creating-react-yk`（本 ROUTER では扱わない）
- **RSC 一般論** → `NEXTJS_RULES` §5（本 ROUTER では再掲しない）
- ui-kit 既存: **`init` / `-b` 再実行禁止** — `add` のみ（L1 §12-3）

---

## 1. 手順（毎タスク）

1. `SHADCN_UI_RULES.md` **§2** で対象確定（未確定ならここで停止）
2. `SKILL.md` → 本 ROUTER で **tier** と **tags** を決める
3. **Ref Plan** をチャットに出力
4. Ref Plan の `load` に列挙したもの **だけ** Read してから編集 / CLI
5. L1 §15 ゲート → 完了報告（触った refs · CLI · §12 or §13）

---

## 2. Tier — floor

| tier | いつ | floor（必ず Read） |
|------|------|----------------------|
| **Light** | 既存 `components/ui` の variant / className のみ | L1 §15 該当項 · 触る 1 ファイル |
| **Standard** | `add` · 既存部品の合成（asChild / render） | **L1 全体** · §12 or §13 · `components.json` |
| **Full** | **初回 init** · theming 横断 · `migrate` · monorepo cwd | L1 + 本 ROUTER §3 tag floor + 公式 1 URL |

**既定:** 迷ったら **Standard**。`components.json` 不存在 + flowchart → **Full** + tag `init-radix`。

---

## 3. Tag — floor に加算

| tag | 追加 floor |
|-----|------------|
| `init-radix` | L1 §13 · [Installation / Next](https://ui.shadcn.com/docs/installation/next) |
| `init-base` | L1 §12 · **新規 ui-kit のみ**（既存 re-init 禁止） |
| `add-component` | L1 §9 · [CLI](https://ui.shadcn.com/docs/cli) · 追加する component 公式 1 本 |
| `flowchart-web` | L1 §13 · `REACTFLOW_RULES.md` shadcn 行 |
| `ui-kit-base-ui` | L1 §12 · `WORKSPACE_RULES` · ui-kit `CLAUDE.md`（Base UI · `--diff`） |
| `theme-css` | L1 §8-2 · [Theming](https://ui.shadcn.com/docs/theming) · `app/globals.css` |
| `monorepo` | L1 §11 · [Monorepo](https://ui.shadcn.com/docs/monorepo) |
| `migrate-radix` | L1 §7 `migrate radix` · CLI docs |

**公式 URL:** 1 tag あたり **1 ページまで**。

**ui-kit ローカル:** `workspace-ui-kit/.claude/skills/shadcn/` は registry 検索・`info --json` **補助**。Base UI / re-init 禁止の正本は **L1 §12** + 本スキル。

---

## 4. シグナル → tag

| シグナル | tag | 禁止 |
|----------|-----|------|
| `flowchart-web-*` · `components.json` なし | `init-radix` + `flowchart-web` | ui-kit で `-b radix` |
| `npx shadcn add` | `add-component` | surge 静的 HTML |
| `asChild` · `@radix-ui` | `flowchart-web` | ui-kit で `asChild` |
| `render` · `@base-ui` | `ui-kit-base-ui` | flowchart で `render` |
| `globals.css` · `@theme` · CSS 変数 | `theme-css` | — |
| `--monorepo` · 複数 `components.json` | `monorepo` | 単体 flowchart/ui-kit に `--monorepo` |
| surge · 静的 HTML 図解 | **タグなし · スキル拒否** | 本スキル起動 |

---

## 5. リポ内パス · L0 優先

| パス | L0 優先 | shadcn lead |
|------|---------|-------------|
| `flowchart-web-*/components/ui/**` | **`reactflow-dev-entry`** → 本スキル | init-radix / add |
| `workspace-ui-kit/components/ui/**` | **`workspace-dev-entry`** → 本スキル | add のみ（init 禁止） |
| その他 `**/components/ui/**` | **`shadcn-dev-entry.mdc`** | Standard |
| `**/components.json` | **`shadcn-dev-entry.mdc`** | §2 確定後 |
| `app/**` のみ | **`nextjs-dev-entry`** — shadcn lead ではない | 委譲のみ |

---

## 6. パージ

- surge 図解 → 本 ROUTER 不使用（L1 §14）
- `lib/flowchart/` → `creating-reactflow-yk`（shadcn 禁止）
- ui-kit `components/primitives/**` → `workspace-dev-entry` + `designing-workspace-ui`（shadcn 生成物ではない）

---

## 7. Ref Plan テンプレート

```markdown
## Ref Plan
- §2 対象: flowchart-web-reactflow | flowchart-web-mermaid | workspace-ui-kit | （surge なら中止）
- tier: Standard（理由を1行）
- tags: add-component, flowchart-web
- load: SHADCN_UI_RULES L1 · components.json · （ROUTER §3 の公式 1 本）
- skip: REACT_RULES（Hooks 不変のため）
- 委譲: creating-nextjs-yk（app/ 同時編集時のみ）
- CLI: （cwd 明示 · 1 行 · add 前 --diff 推奨）
```

---

## 8. 完了報告（末尾必須）

- §2 対象（flowchart / ui-kit）
- tier / tags
- 実行した CLI（cwd 含む）
- **読んだ refs**（L1 · ROUTER · ファイル · 公式 URL）
- L1 §15 チェックリスト該当項
