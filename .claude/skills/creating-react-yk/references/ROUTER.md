# React 参照ルーティング（ROUTER）

**SSOT:** 本ファイルが tier · tag · Ref Plan テンプレの唯一の正本。  
**要約・MUST:** `yk-skill/rule/30_web_stack/REACT_RULES.md` · **手順:** `../SKILL.md`  
**設計パターン:** `yk-skill/rule/10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md`

**最終更新:** 2026-05-24

---

## 0. 禁止・原則

- `REACT_RULES.md` を毎ターン全文 Read する必要はないが、**Client コードを Write/StrReplace するターンでは L1 を Read 済み**であること
- 公式 react.dev ページは **tag に該当するときだけ** Read（Ref Plan の `load` に列挙）
- tier / tag 表を `SKILL.md` や L1 に **複製しない**
- **RSC / `"use client"`** → `NEXTJS_RULES` §5（本 ROUTER では扱わない）

---

## 1. 手順（毎タスク）

1. `REACT_RULES.md` → `SKILL.md` を読む
2. 本 ROUTER で **tier** と **tags** を決める
3. RSC 境界が絡む → `NEXTJS_RULES` §5 を floor に追加
4. **Ref Plan** をチャットに出力
5. Ref Plan の `load` に列挙したもの **だけ** Read してから編集
6. `REACT_RULES.md` §6 ゲート → §7 完了報告

---

## 2. Tier — floor

| tier | いつ | floor（必ず Read） |
|------|------|----------------------|
| **Light** | 文言 · className · レイアウトのみ · Hooks 不変 | L1 §2 または該当 1 ファイル |
| **Standard** | Hook 追加 · state 変更 · 複数コンポーネント | **L1 全体** + §3 Tag floor |
| **Full** | 新カスタム Hook 契約 · Context 追加 · 性能 refactor 横断 | L1 + 該当 tag 公式 1 ページ |

**既定:** 迷ったら **Standard**。

---

## 3. Tag — floor に加算

| tag | 追加 floor |
|-----|------------|
| `hooks` | [Rules of Hooks](https://react.dev/reference/rules/rules-of-hooks) · [Components and Hooks must be pure](https://react.dev/reference/rules/components-and-hooks-must-be-pure) |
| `client-component` | `NEXTJS_RULES.md` §5 + 触る `components/**/*.tsx` |
| `forms-actions` | [useActionState](https://react.dev/reference/react/useActionState) · [useOptimistic](https://react.dev/reference/react/useOptimistic) · [useFormStatus](https://react.dev/reference/react-dom/hooks/useFormStatus) |
| `performance` | ui-kit 作業時: リポ内 `vercel-react-best-practices` スキル（該当カテゴリのみ Ref Plan 列挙） |
| `ui-kit` | `WORKSPACE_RULES.md` §3 · ui-kit `coding-rules.md`（パスは Ref Plan に明示） |

**公式 URL:** 1 tag あたり **1 ページまで**（L1 §4-0）。

---

## 4. シグナル → tag

| シグナル | tag |
|----------|-----|
| `useState` · `useEffect` · カスタム Hook | `hooks` |
| `"use client"` · Server 子 import | `client-component` |
| form action · 楽観 UI | `forms-actions` |
| memo · 再レンダー · リスト性能 | `performance` |
| `workspace-ui-kit` | `ui-kit` |

---

## 5. リポ内パス

| パス | いつ load |
|------|-----------|
| `c:/yk-tool/workspace-ui-kit/components/**` | ui-kit Client 作業 |
| `c:/yk-tool/flowchart-web-*/components/flowchart/**` | flowchart Client（**RF 併用** — `creating-reactflow-yk`） |

---

## 6. パージ

- Light + tag なし → L1 §2 のみで足りるなら公式 Read しない
- React 19 API 未使用プロジェクトで `forms-actions` tag を付けない

---

## 7. Ref Plan テンプレート

```markdown
## Ref Plan
- tier: Standard（理由を1行）
- tags: hooks
- load: REACT_RULES L1 · components/Foo.tsx · （必要なら react.dev URL）
- skip: NEXTJS §5（RSC 不変のため）
- 委譲: なし
```

---

## 8. 完了報告（末尾必須）

- 触ったファイル一覧
- tier / tags
- **読んだ refs**（L1 · ROUTER · ファイル · 公式 URL）
