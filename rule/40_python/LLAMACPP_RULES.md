# llama.cpp 参照ルール

## このルールが必要な背景

ローカル LLM 推論エンジン **llama.cpp**（GGUF · `llama-server`）を扱うときの MUST / やらないこと。YK では `local-llm-core` が OpenAI 互換クライアント経由で接続する想定。**製品の移行タイミング・現行ランタイムの正本はアプリ docs**（本 L1 はエンジン規律）。

**ファイルパス（エージェント参照用）:** `c:/yk-skill/rule/40_python/LLAMACPP_RULES.md`

**ステータス:** `draft`（[`RULE_INDEX.md`](../RULE_INDEX.md) No 43）— L1 要約。**専用スキル · L0 entry · ROUTER は未整備**（PROGRESSIVE 段階 1）。  
**draft でも** §3・§9 の MUST は従う。未確定（実測パス・採用バイナリ名の最終表記）は §12 R2 まで埋めない。

**親ルール:** [`PYTHON_RULES.md`](PYTHON_RULES.md)（Python クライアント側）· [`SECRETS_HYGIENE_RULES.md`](../10_meta/SECRETS_HYGIENE_RULES.md) · [`AGENT_SHELL_RULES.md`](../60_tooling/AGENT_SHELL_RULES.md)

**最終更新:** 2026-09-13（2周目レビューで収束）

---

## 0. エージェント向け — いつ何を読むか

| 段階 | 読むもの | タイミング |
|------|----------|------------|
| L1 | **本ファイル** | llama.cpp · GGUF · `llama-server` · ローカル推論バックエンドを触るたび・最初 |
| L1（クライアント） | [`PYTHON_RULES.md`](PYTHON_RULES.md) | `llm_core` / Python から OpenAI 互換 API を叩くとき |
| 製品方針 | `local-llm-core` の検討・導入計画（§11） | 移行順序・現行バックエンド・自動起動の製品仕様が必要なときだけ |

**Ref Plan（スキル未整備時）:** 着手前にチャットで **tier（下記）· 触る節 · 読む `local-llm-core` パス** を1行固定する。  
**Shell:** 下記コマンド例は**概念のみ**。ビルド・ダウンロード・サーバ起動の実行は [`AGENT_SHELL_RULES`](../60_tooling/AGENT_SHELL_RULES.md) に従い、**ユーザーが当ターンで明示したときだけ**。

### 読む深さ

| モード | 条件 | 読む節 |
|--------|------|--------|
| **Light** | 用語確認 · Ollama との違い | §0–§2 · §9 |
| **Connect** | `base_url` / config 接続のみ（ビルドしない） | §0 · §3 · §6–§7 · §9 |
| **Standard** | インストール · GGUF 入手 · `llama-server` 起動手順の整理 | §0–§3 · §5–§7 · §9 + §10/§11 索引 |
| **Deep** | Vulkan/CUDA ビルド · 自前変換・量子化 · 公式の詳細 | Standard + §4 · §8 + 公式 `docs/build.md` / `tools/server` |

### 本ファイルで扱わない（委譲 SSOT）

| 関心 | SSOT |
|------|------|
| `llm_core.generate()` · config · パッケージ構成 | `c:/yk-application/local-llm-core/`（コード · docs） |
| Ollama → llama.cpp **移行決定・アクション順序** | `.../検討_2026-09-13_Ollama-vs-llamacpp.md` |
| 現行「何が動いているか」· AGENTS 一文 | 同リポ `AGENTS.md` · 導入計画（**移行反映完了まで Ollama 記載が残ってよい**） |
| 会話ログ · RAG · `llm_chat` | `.../計画_2026-09-12_個人チャットRAG拡張計画.md` |
| `.env` · API キー | [`SECRETS_HYGIENE_RULES.md`](../10_meta/SECRETS_HYGIENE_RULES.md) |
| Agent Shell 可否 | [`AGENT_SHELL_RULES.md`](../60_tooling/AGENT_SHELL_RULES.md) |

### 誤ルーティング禁止

| 触るもの | 使う | 使わない |
|----------|------|----------|
| GGUF · `llama-server` · 量子化 · Vulkan/CUDA ビルド | **本ファイル** | Ollama 手順だけで llama.cpp 作業を代替 · `PYTHON_RULES` のみで推論エンジンを推測 |
| OpenAI 互換クライアント（Python） | Connect/Standard + `PYTHON_RULES` + `local-llm-core` | FastAPI をローカル LLM サーバの代替にする |
| クラウド LLM | 対象外 | 本ファイルにクラウド手順を足す |

---

## 1. llama.cpp とは（要約）

| 項目 | 内容 |
|------|------|
| **用途** | C/C++ による **LLM（および VLM）推論**。最小依存で CPU/GPU 上に載せる |
| **公式リポ** | https://github.com/ggml-org/llama.cpp （MIT） |
| **テンソル基盤** | [ggml](https://github.com/ggml-org/ggml) |
| **モデル形式** | **GGUF**（単一ファイルに重み・トークナイザ・メタデータ） |
| **主な入口** | CLI · **HTTP サーバ**（OpenAI 互換 · Web UI）· ライブラリ |
| **インストール経路** | [llama.app](https://llama.app) · [Releases](https://github.com/ggml-org/llama.cpp/releases) · Docker · Winget · ソース CMake（`docs/build.md`） |

製品側の「なぜ llama.cpp か」は検討ドキュメント §5。本 L1 は繰り返さない。

---

## 2. いつ使う / いつ使わない

| 使う | 使わない |
|------|----------|
| ローカルで GGUF を推論する（CLI または API） | クラウド API を本線にする |
| OpenAI 互換 `base_url` で自作クライアントから接続 | アプリ内に学習・ファインチューニングを持ち込む |
| ハードウェアに合わせたバックエンド（CPU · **Vulkan** · CUDA · Metal 等） | **NPU 専用ランタイム**を llama.cpp で代替する前提 |
| YK 既定: **単一モデル起動**（`-m` / `-hf`） | 公式の router / `--models-dir` を YK 製品に先取り導入する（必要なら別途決定） |

---

## 3. アーキテクチャ — MUST（エンジン）

```text
[クライアント: llm_core 等]
        │  OpenAI 互換 HTTP
        │  base_url = http://127.0.0.1:<port>/v1
        ▼
[llama-server]  ← YK 既定は起動時 **-m / -hf の 1 GGUF**
        ▼
[GGUF ファイル]
```

| MUST | 内容 |
|------|------|
| **クライアント抽象** | 公開 API は自前（例: `generate`）。内部だけが OpenAI 互換を叩く |
| **移行作業・新規 llama.cpp 設定** | 接続先は `llama-server` を想定する。**現行 PC でまだ Ollama が動いていること自体は矛盾ではない**（移行完了までは併用期間あり。製品の「今の既定」は AGENTS / 導入計画） |
| **バインド** | `--host 127.0.0.1`（LAN 公開は明示依頼までしない） |
| **ポート** | **必ず `--port` を明示**（推奨 `8080`）。省略既定は将来変わりうる（公式で 9931 への移行が議論されている） |
| **YK のモデル数** | 単一 GGUF モードを使う。task 別マルチモデルは製品方針で当面やらない（詳細は検討ドキュメント） |
| **Git** | GGUF / 巨大キャッシュをリポにコミットしない |

---

## 4. インストール・ビルド（Deep）

詳細は常に [docs/build.md](https://github.com/ggml-org/llama.cpp/blob/master/docs/build.md)。例は概念のみ（§0 Shell）。

| 経路 | いつ |
|------|------|
| Releases / Winget / llama.app | まず動かす |
| ソース（CMake） | GPU バックエンドを明示したい |
| Docker | 隔離環境（`docs/docker.md`） |

| 環境 | CMake 例 | メモ |
|------|----------|------|
| CPU | （既定） | 最小確認 |
| NVIDIA | `-DGGML_CUDA=ON` | Toolkit 必須 |
| **AMD iGPU（OmniBook 等 · Windows）** | **`-DGGML_VULKAN=ON` を初手** | HIP/ROCm は Linux・対応 dGPU 向けの上級。Windows iGPU では推奨しない |
| Apple Silicon | Metal | YK 日常 PC 外 |

実行時は `--list-devices` / `--device` で確認（公式）。

**コマンド表記（本 L1 の既定）:** 本文例は **`llama-server` / `llama-cli`**。公式 Quick start の `llama serve` / `llama cli` は同一系統の別表記。**別名を推測して勝手に実行しない**（R2 で実機の実名を1行追記）。

---

## 5. GGUF · 量子化

| 項目 | 方針 |
|------|------|
| **形式** | `.gguf` のみ |
| **入手（推奨順）** | ① 既製 GGUF（HF · `-hf org/repo[:quant]`）② 自前変換→量子化（§8） |
| **初手の候補** | `Q4_K_M`（広く使われる出発点）。**採用バリアントの確定は製品の GGUF 方針**（検討ドキュメント §6 アクション1） |
| **品質寄り** | RAM/VRAM に余裕があれば `Q5_K_M` 等を実機で比較 |
| **保存先** | ローカル専用ディレクトリ。クラウド同期フォルダに置かない |
| **日本語** | Instruct 系 GGUF を選ぶ。変換時の語彙不整合に注意 |

```bash
# 概念例（実行はユーザー明示時のみ）
llama-cli -hf org/model-GGUF:Q4_K_M
llama-cli -m /path/to/model-Q4_K_M.gguf -cnv -c 4096 -ngl 99
```

`-ngl` / `-c` はメモリに合わせて下げる。

---

## 6. llama-server（API）— MUST

| 項目 | 内容 |
|------|------|
| **Chat** | `POST /v1/chat/completions` |
| **Models** | `GET /v1/models` |
| **Health** | `GET /health` — **利用可 = HTTP 200 かつ ready**。読込中は **503** → リトライ。接続拒否のみ「未起動」 |
| **Web UI** | `http://127.0.0.1:<port>/`（疎通用。製品 UI ではない） |
| **Ollama ポート** | 11434 と混同しない |

```bash
# 概念例 — host/port は明示（§3）
llama-server -m /path/to/model-Q4_K_M.gguf --host 127.0.0.1 --port 8080 -ngl 99 -c 4096
llama-server -hf org/model-GGUF:Q4_K_M --host 127.0.0.1 --port 8080
```

（公式 Quick start 表記は `llama serve` — 実機のバイナリ名は §4 · R2）

Python: `base_url="http://127.0.0.1:8080/v1"`。`--api-key` 使用時は Secrets 規律。

**自動起動・ヘルスチェックの製品実装**は検討ドキュメント §5.1 / §6。本 L1 はエンドポイント意味だけ持つ。

---

## 7. クライアント統合

| MUST | 内容 |
|------|------|
| 移行後の config | `base_url` / model を **llama-server** 向けに合わせる |
| 接続失敗 | 未起動 · ポート · GGUF パス · Health 503 を疑う（クライアント再実装を先にしない） |
| embedding | chat 用 GGUF と混同しない（RAG 計画側） |

---

## 8. 変換・量子化（Deep）

```text
HF → convert_hf_to_gguf → F16 GGUF → llama-quantize → Q4_K_M 等
```

切り分けでは F16 でトークナイザ確認してから量子化。未対応アーキテクチャは llama.cpp 更新後に再試行。

---

## 9. やらないこと（禁止・注意）

| 禁止・注意 | 理由 |
|------------|------|
| GGUF を Git にコミット | 肥大 · 機密 |
| `--host 0.0.0.0` を黙って有効化 | 意図しない公開 |
| Ollama と llama-server を同一ポートで共存 | 衝突 |
| 「Ollama と同じ操作」前提の手順 | pull / タグ体系が異なる |
| ベンチ倍率を事実として固定 | 体感確認が正 |
| NPU を llama.cpp 前提にする | 本線は CPU/GPU（Vulkan 等） |
| YK で公式 router を断りなく導入 | 製品方針は単一 GGUF。能力はあるが別決定 |
| コマンド例をユーザー明示なしに Shell 実行 | `AGENT_SHELL_RULES` |

**Windows:** コンソール UTF-8（例: `chcp 65001`）を意識。

---

## 10. 公式ソース（索引）

| 種別 | URL |
|------|-----|
| リポジトリ | https://github.com/ggml-org/llama.cpp |
| ビルド | https://github.com/ggml-org/llama.cpp/blob/master/docs/build.md |
| Server | https://github.com/ggml-org/llama.cpp/tree/master/tools/server |
| Releases | https://github.com/ggml-org/llama.cpp/releases |

手順の正本は常に公式リポ。

---

## 11. YK 関連パス

| 用途 | パス |
|------|------|
| アプリ憲法 | `c:/yk-application/local-llm-core/AGENTS.md` |
| 移行決定 | `c:/yk-application/local-llm-core/docs/01_要求定義/検討_2026-09-13_Ollama-vs-llamacpp.md` |
| 導入計画 | `c:/yk-application/local-llm-core/docs/01_要求定義/計画_2026-09-12_ローカルLLM導入計画.md` |
| RAG 計画 | `c:/yk-application/local-llm-core/docs/01_要求定義/計画_2026-09-12_個人チャットRAG拡張計画.md` |
| handoffs | `c:/yk-memo/handoffs/local-llm-core/HANDOFF.md` |

---

## 12. ロードマップ（メンテナ向け · 通常の実装依頼では読まない）

| フェーズ | 内容 | 完了条件 |
|----------|------|----------|
| R0 | Web 調査 + L1 + 索引登録 | 済 |
| R1 | サブエージェント収束レビュー | 済（2周で収束） |
| R2 | 実機追記（Vulkan · GGUF パス · バイナリ実名 · ポート） | §4–§6 に1行 |
| R3（任意） | スキル / ROUTER / L0 · Status `active` | 人間判断 |

---

## 13. レビューの経緯

- **1周目（SME / 報告先 / 第三者·SSOT）:** 単一モデルを「エンジン非対応」と誤記→YK 方針と能力を分離。HIP を Windows iGPU 初手から外す。`--port` 明示 · Health 503 · Ref Plan/Shell/Connect モード · draft MUST 注記 · 製品決定の二重 SSOT を条件付き表現に · Q4 を「初手候補」に弱め · ロードマップをメンテナ向け注記。中以上を反映。
- **2周目（技術整合の再検証 / 編集·様式 / セキュリティ）:** 1周目5項目の反映を確認。3レンズとも「重大な問題なし」→**収束**。§6 の `≈` 表記のみ任意で緩和。
