# Playwright 参照ルーティング（ROUTER）

**SSOT:** 本ファイルが spec 執筆時の **L3 読み順** の正本。  
**L1 要約:** `yk-skill/rule/50_gas_html_test/PLAYWRIGHT_RULES.md`  
**手順:** `../SKILL.md` · 戦略設計は `designing-playwright-tests-yk`

**最終更新:** 2026-06-27（P14c 新設）

---

## 0. 禁止・原則

- L1 §12-13 の **全文を毎ターン Read しない** — 索引 → 本 ROUTER → 該当 `references/` のみ
- GAS / Sheets 以外は **§1–11 を毎回深読しない**
- decision-matrix を L1 に複製しない

---

## 1. 手順（spec 執筆・実行）

1. `PLAYWRIGHT_RULES.md`（L1）を Read
2. **新規 spec / 大規模 E2E** — §13 索引 → `PLAYWRIGHT_TEST_STRATEGY.md` + `decision-matrix.md`（設計済みなら省略可 · SKILL Step 0）
3. 本 ROUTER で **tag** を決める
4. `references/PLAYWRIGHT_AGENT_OPS.md` の該当 §12-x を Read
5. spec 執筆 → `npm run test:e2e` 等（`AGENT_SHELL_RULES` §3-2）

---

## 2. Floor — いつ何を Read

| いつ | floor（必ず Read） |
|------|-------------------|
| **回帰 1 本 · UI 修正同一ターン** | L1 §12 索引 + `PLAYWRIGHT_AGENT_OPS.md` の該当 §12-x のみ |
| **新規 spec · 複数フロー** | 上記 + `PLAYWRIGHT_TEST_STRATEGY.md` + `decision-matrix.md` |
| **GAS / Sheets E2E** | L1 §1–11 + §12 索引 + 該当 §12-x |
| **flowchart-studio E2E** | `PLAYWRIGHT_AGENT_OPS.md` §12-3 · §12-6 · §12-8（触る範囲に応じて） |

**既定:** 迷ったら **Standard** = L1 + `PLAYWRIGHT_AGENT_OPS.md` 全文（~160行 · GAS 時は §1–11 追加）。

---

## 3. Tag — 追加 Read（`50_gas_html_test/references/`）

| tag | 追加 Read |
|-----|-----------|
| `geometry` | `PLAYWRIGHT_AGENT_OPS.md` §12-3 |
| `flowchart` | §12-6 · §12-8 + REACTFLOW `references/`（ROUTER tag に応じて） |
| `server-action-stub` | §12-7 + [`SUPABASE_AUTH_SSR.md`](../../../rule/30_web_stack/references/SUPABASE_AUTH_SSR.md) §8-2 |
| `strategy` | `PLAYWRIGHT_TEST_STRATEGY.md` + `decision-matrix.md` |
| `gas` | L1 §1–11 · §4 · §7 |

**複数 tag:** Ref Plan または SKILL 完了報告に列挙。

---

## 4. シグナル → tag

| シグナル | tag |
|----------|-----|
| 重なり · boundingBox · `toPass` | `geometry` |
| `flowchart-studio` · `e2e/*.spec.ts` | `flowchart` |
| `importEquipmentBundle` · `deleteModule` · `e2eStub` | `server-action-stub` |
| 新規ユーザーフロー · クリティカルパス | `strategy` |
| GAS iframe · Sheets · `session.json` | `gas` |

---

## 5. Ref Plan テンプレ（任意 · 大規模 E2E）

```markdown
## Ref Plan
- tags: flowchart, geometry
- load: PLAYWRIGHT_RULES.md §12, references/PLAYWRIGHT_AGENT_OPS.md §12-3, references/PLAYWRIGHT_AGENT_OPS.md §12-8
- skip: §1–11（GAS 非該当）
```
