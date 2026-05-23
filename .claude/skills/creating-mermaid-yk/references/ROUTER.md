# Mermaid 参照ルーティング（ROUTER）

**SSOT:** 本ファイルが tier · tag · Ref Plan テンプレの唯一の正本。  
**要約・MUST:** `yk-skill/rule/45_mermaid/MERMAID_RULES.md` · **手順:** `../SKILL.md`  
**設計パターン:** `yk-skill/rule/10_meta/PROGRESSIVE_CONTEXT_ROUTING_RULES.md`

**最終更新:** 2026-05-23

---

## 0. 禁止・原則

- `MERMAID_RULES.md` を毎ターン全文暗記する必要はないが、**.mmd を Write/StrReplace するターンでは L1 を Read 済み**であること
- 公式構文ページを **tag に該当するときだけ** Read（Ref Plan の `load` に列挙）
- tier / tag 表を `SKILL.md` や `MERMAID_RULES.md` §9 に **複製しない**（リンクのみ）

---

## 1. 手順（毎タスク）

1. `MERMAID_RULES.md` → `SKILL.md` を読む
2. 本 ROUTER で **tier** と **tags** を決める
3. **Ref Plan** をチャットに出力（`SKILL.md` Step 0.1 — Light は短形式）
4. Ref Plan の `load` に列挙したもの **だけ** Read してから `.mmd` 編集
5. `MERMAID_RULES.md` §7 品質ゲート → §8 完了報告（**読んだ refs** を1行以上）

---

## 2. Tier — floor

| tier | いつ | floor（必ず Read） |
|------|------|----------------------|
| **Light** | 1 ファイル · ラベル/typo/コメントのみ · 図種・分岐構造は変えない | `MERMAID_RULES.md` §3（構文 MUST）のみで足りるときは §3 参照に限定可 |
| **Standard** | 新規図 · 分岐追加 · 複数 `.mmd` · 200 行に近づく分割 | **`MERMAID_RULES.md` 全体（L1）** |
| **Full** | 新規 `diagrams/` プロジェクト · 公開パイプライン · `securityLevel` 変更 | L1 + tag `deploy`（§5）· リポの `diagrams/README.md`（存在すれば） |

**既定:** 迷ったら **Standard**（Light の過小評価を避ける）。

**Light でも Standard に上げる条件（いずれか）:**

- 図種変更 · 新規 subgraph 階層 · エッジの意味変更
- 複数ファイル · `package.json` / mmdc 導入
- ユーザーが「品質ゲート厳守」を明示

---

## 3. Tag — floor に加算（OR）

| tag | 追加で Read / 確認 |
|-----|-------------------|
| `flowchart` | `MERMAID_RULES.md` §3 · §11 |
| `sequence` | `MERMAID_RULES.md` §4 + [sequenceDiagram 公式](https://mermaid.js.org/syntax/sequenceDiagram.html) |
| `state` | `MERMAID_RULES.md` §4 + [stateDiagram 公式](https://mermaid.js.org/syntax/stateDiagram.html) |
| `er` | `MERMAID_RULES.md` §4 + [erDiagram 公式](https://mermaid.js.org/syntax/entityRelationshipDiagram.html) |
| `deploy` | `MERMAID_RULES.md` §5 + ホストの `mermaid.initialize` 設定（該当リポのドキュメント） |
| `cli` | `MERMAID_RULES.md` §7（mmdc）· Agent Shell 規律（`AGENT_SHELL_RULES.md`） |

**複数 tag:** Ref Plan にすべて列挙。公式 URL は **1 tag あたり 1 ページ**まで（過剰 Read 禁止）。

---

## 4. シグナル → tag 推定

| シグナル | tag |
|----------|-----|
| `flowchart` / `graph` · `.mmd` 業務フロー | `flowchart` |
| `sequenceDiagram` | `sequence` |
| `stateDiagram` | `state` |
| `erDiagram` | `er` |
| 公開サイト · `securityLevel` · XSS 懸念 | `deploy` |
| `mmdc` · `package.json` · CI 検証 | `cli` |

---

## 5. リポ内パス（任意 floor）

| パス | いつ load に含める |
|------|-------------------|
| `<リポ>/diagrams/README.md` | 当該プロジェクトで図を触る · Full tier |
| `<リポ>/diagrams/overview.mmd` 等 | 編集対象ファイル（Ref Plan の `load` にパス明記） |

正本例: `yk-skill/rule/45_mermaid/diagrams/`

---

## 6. パージ

- 同一公式ページを複数 tag で二重指定しない
- Ref Plan の `skip` に「読まないものと理由」を 1 行以上（**Light は省略可**）

---

## 7. Ref Plan テンプレート

### Light（短形式）

```markdown
## Ref Plan
- tier: Light（例: overview.mmd のラベル修正のみ）
- load: c:/yk-skill/rule/45_mermaid/MERMAID_RULES.md §3
```

### Standard / Full（フル形式）

```markdown
## Ref Plan
- tier: Standard（例: 新規 detail-foo.mmd）
- tags: flowchart
- load: c:/yk-skill/rule/45_mermaid/MERMAID_RULES.md, c:/yk-skill/rule/45_mermaid/diagrams/README.md
- skip: sequence 公式（本タスクは flowchart のみ）
```

---

## 8. 完了報告（tier 別）

`MERMAID_RULES.md` §8 に従う。末尾に **読んだ refs**（L1 · ROUTER · 公式 URL · 触った `.mmd`）を列挙。
