# テスト種別の決定マトリクス

**SSOT:** 本ファイル。`PLAYWRIGHT_RULES` §13 は索引 + 本ファイルへのリンク。

## テストピラミッド（YK 既定）

| 層 | 割合目安 | 担当 | Playwright |
|----|----------|------|------------|
| 単体 | 55〜65% | Vitest 等 | 使わない |
| 結合 | 25〜30% | Vitest + MSW / API Feature / `request` fixture | 使わない |
| E2E | **5〜15%** | Playwright | クリティカルパスのみ |

**レビュートリガー（YK ヒューリスティック · Playwright 公式外）:** E2E が **150 件超**、または E2E が全テストの **15% 超** / CI E2E が目安時間超 → 下位層へ移せるシナリオがないか `designing-playwright-tests-yk` で再点検。

## 選定フロー

```
1. ユーザーが直接体験するか？ → No → Vitest / API
2. 下位層だけで十分か？       → Yes → Vitest / API（E2E 不要）
3. 壊れると信頼・作業不能に直結か？ → No → E2E 優先度を下げる
4. DOM / 描画 / 操作が必要か？ → Yes → Playwright E2E
5. ピクセル一致が必要か？     → 最終手段 toHaveScreenshot
```

## Playwright E2E 向き

- 認証・セッション・リダイレクトを跨ぐフロー
- ユーザーが **見える・触れる** 表示・操作・文言・件数
- 複数画面 / iframe / 実ブラウザ描画が必要なジャーニー
- レイアウト（重なり・左右）— `PLAYWRIGHT_RULES` §12-3
- キーボード・フォーカス（axe だけでは不足）
- GAS iframe / Sheets — §4–7

## Playwright E2E 向かない

- 純ロジック（座標計算・parse・分岐）→ Vitest
- フォーム全バリデーション組み合わせ → 単体 / API
- 個別 API 契約 → `request` / Feature テスト
- コンポーネント内部 state → Vitest（Playwright CT は experimental · 採用時のみ designing で明示）
- CSS クラス・実装詳細の存在確認
- 自社が制御できない外部サイト
- 全ブレークポイントのレスポンシブ

## シナリオ別

| シナリオ | 推奨 | 理由 |
|----------|------|------|
| ログイン / セッション | E2E + storageState | cookie・リダイレクト |
| CRUD の各バリデーション | 単体 / API | E2E は遅く脆い |
| サンプル読込 → 図生成 → 件数 | E2E | 描画 + 操作の一体 |
| エッジラベルと縦線の gap | E2E + 幾何 | DOM 座標のみ E2E で |
| buildEdges の分岐 | Vitest | ロジック |
| GAS iframe レポート表示 | E2E | iframe + 実ブラウザ |
| モーダルの Tab トラップ | E2E + keyboard | axe 単体では不足 |
| WCAG コントラスト・label | axe（任意） | 自動監査 |
| 全ページ smoke | E2E 少数 | クリティカル URL のみ |

## アンチパターン

| パターン | 問題 | 代替 |
|----------|------|------|
| 全 UI を E2E | 遅い・メンテ高 | ピラミッド |
| 1 spec で全ジャーニー | 失敗箇所不明 | フロー単位に分割 |
| UI 毎回ログイン | 遅い | storageState / API setup |
| waitForTimeout | フラキー | web-first assert |
| CSS nth-child | 壊れやすい | getByRole / data-* 契約 |
| テスト間で DB 共有 | 順序依存 | 各テストが seed |

## 組織単位

- **ユーザーストーリー単位**で describe（ページ単位ではない）
- **1 test = 1 検証意図**（複数 assert は同一状態なら可）
- Page Object は **同一モジュール 10 spec 超** で検討

## spec 追加前チェックリスト

- [ ] 下位層だけで代替できないか確認した
- [ ] 壊れると **信頼・作業不能** に直結するパスか
- [ ] 1 test = 1 検証意図（巨大ジャーニー spec を避ける）
- [ ] 再現手順（サンプル読込・モジュール選択等）を spec 骨子に含めた
- [ ] セットアップは UI より API / fixture / `storageState` を優先
