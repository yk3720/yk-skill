# GAS 設計ルール
## Google Apps Script Web アプリ開発 — Design & Development Rules v2

**最終更新:** 2026-06-27（P14d · §1 · §3 · §7-8 を `references/` へ分割）
**索引:** [`RULE_INDEX.md`](../RULE_INDEX.md) No 51

---

## 0. GAS 実行環境の前提

| 項目 | 内容 |
|------|------|
| ランタイム | **V8**（モダン JavaScript。`const`/`let`/クラス/arrow function 等が使える） |
| 1 回の最大実行時間 | **6 分**（トリガー実行含む） |
| サンドボックス | **IFRAME モード固定**（`setSandboxMode()` は効果なし） |
| タイムゾーン | `appsscript.json` の `timeZone` で指定（`"Asia/Tokyo"` 推奨） |

**`appsscript.json` 基本設定（必須）：**

```json
{
  "timeZone": "Asia/Tokyo",
  "runtimeVersion": "V8",
  "exceptionLogging": "STACKDRIVER",
  "oauthScopes": [
    "https://www.googleapis.com/auth/spreadsheets",
    "https://www.googleapis.com/auth/script.external_request"
  ]
}
```

> `oauthScopes` は実装に必要な最小限のみ宣言する（最小権限の原則）。

---

## 1. GAS HTML Service（索引）

**詳細:** [`references/GAS_HTML_SERVICE.md`](references/GAS_HTML_SERVICE.md) — viewport · CSS · Tailwind · ALLOWALL

| 節 | 内容 |
|----|------|
| §1-1 | `addMetaTag` viewport · XFrameOptionsMode |
| §1-2 | インラインスタイル禁止 |
| §1-3 | Tailwind CDN 共存 |

---

## 2. GAS テンプレート構文ルール

### 2-1. テンプレートタグの種類と使い分け

| タグ | 用途 | エスケープ |
|------|------|-----------|
| `<? ... ?>` | GAS コードブロック（出力なし） | — |
| `<?= ... ?>` | 値を出力（**HTML エスケープあり**） | ✅ 自動エスケープ |
| `<?!= ... ?>` | 値を出力（**エスケープなし・生 HTML**） | ❌ 手動で対応必要 |

```html
<!-- ✅ テキスト値には = を使う（XSS 防止） -->
<td><?= row.subject ?></td>

<!-- ✅ HTML 文字列（バッジ等）には != を使う -->
<td><?!= statusBadge(row.status) ?></td>

<!-- ❌ HTML 文字列を = で出力すると < > がエスケープされて壊れる -->
<td><?= statusBadge(row.status) ?></td>
```

### 2-2. JSON の安全な埋め込み

```html
<script>
var PLANNED_DATA = <?!= JSON.stringify(planned).replace(/<\//g, '<\\/') ?>;
</script>
```

### 2-3. テンプレートタグは絶対に削除・変形しない

HTML エディタや整形ツールがこれらを壊す場合があるため、手動編集時は特に注意する。

---


## 3. データ設計（索引）

**詳細:** [`references/GAS_DATA_DESIGN.md`](references/GAS_DATA_DESIGN.md) — 列定数 · STATUS/CATEGORY

---

## 4. シート・ファイル管理ルール

### 4-1. シート名はスクリプトプロパティで管理する

```javascript
const SHEET_NAME = PropertiesService.getScriptProperties()
  .getProperty('SHEET_NAME') || '入力フォーム';
```

### 4-2. スクリプトプロパティ・シークレット管理

**横断方針:** [`10_meta/SECRETS_HYGIENE_RULES.md`](../10_meta/SECRETS_HYGIENE_RULES.md) · [`GIT_WORKFLOW_RULES.md`](../10_meta/GIT_WORKFLOW_RULES.md) §2

**トークン・シークレットは Script Properties に置き、ソースコードに直書きしない。**

```javascript
// 使用するスクリプトプロパティ一覧（コメントで明記する）
// SPREADSHEET_ID : 対象スプレッドシートのID
// SHEET_NAME     : データ入力シート名（デフォルト: '入力フォーム'）
// LINE_TOKEN     : LINE Messaging API チャンネルアクセストークン
// LINE_CHANNEL_SECRET : LINE Webhook 署名検証用シークレット
// LINE_USER_ID   : 通知先 LINE ユーザーID
// REPORT_URL     : GAS Web アプリ公開 URL
```

---

## 5. デプロイルール

### 5-1. 変更を反映するには「新しいバージョン」として再デプロイが必要

```
変更手順:
1. コードを編集・保存
2. 「デプロイ」→「デプロイを管理」
3. 既存のデプロイを選択→「編集」→「バージョン: 新しいバージョン」
4. デプロイ
```

> **単なる上書き保存だけでは既存の URL に変更が反映されない。**

**テストデプロイ（`…@dev`）との違い**:

| URL | 特性 |
|-----|------|
| `…/exec` | バージョン固定の本番 URL。保存しただけでは変わらない |
| `…/dev` | 常に最新コードで動く開発用 URL。認証ユーザーのみアクセス可 |

### 5-2. テスト関数を用意する

```javascript
function testReport() {
  const rows    = getDataRows_();
  const planned = buildPlanned_(rows);
  const trouble = buildTrouble_(rows);
  Logger.log('定期: ' + planned.length + '件 / トラブル: ' + trouble.length + '件');
}
```

---

## 6. セキュリティルール

### 6-1. LINE Webhook は署名検証を必ず実施する

```javascript
// HMAC-SHA256 でリクエストの正当性を検証
// 注意: rawBody は文字列の完全一致が必要（再シリアライズ禁止）
if (LINE_CHANNEL_SECRET) {
  const expectedSig = Utilities.base64Encode(
    Utilities.computeHmacSha256Signature(rawBody, LINE_CHANNEL_SECRET)
  );
  if (expectedSig !== signature) {
    return ContentService.createTextOutput(JSON.stringify({ status: 'forbidden' }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}
```

### 6-2. エラーメッセージの HTML エスケープ

```javascript
const safeMsg = String(err.message)
  .replace(/&/g, '&amp;')
  .replace(/</g, '&lt;')
  .replace(/>/g, '&gt;');
```

### 6-3. Web アプリの認可モデルに注意する

デプロイ時の「実行ユーザー」と「アクセス権限」によりスプレッドシートの見え方が変わる。

| 実行ユーザー | アクセス権限 | 動作 |
|------------|------------|------|
| スクリプトオーナー | 全員（匿名を含む） | オーナー権限でシートを読む（データ全開示リスク） |
| アクセスするユーザー | 組織内 | ユーザー権限でシートを読む（適切な場合が多い） |

> **匿名アクセス＋オーナー実行**の組み合わせは、認証なしで全データが見える。用途を慎重に選択すること。

---

## 7–8. パフォーマンス · データ処理（索引）

**詳細:** [`references/GAS_RUNTIME.md`](references/GAS_RUNTIME.md)

| 節 | 内容 |
|----|------|
| §7 | バッチ I/O · 6 分制限 · Cache · Lock |
| §8 | trim · 日付 TZ · 数値クランプ |

---

## 9. モバイル対応チェックリスト

| チェック項目 | 対応方法 |
|------------|---------|
| ✅ viewport 設定 | `doGet()` 内で `addMetaTag('viewport', 'width=device-width, initial-scale=1')` |
| ✅ CSS メディアクエリ | `@media (max-width: 639px)` で上書き |
| ✅ インラインスタイル排除 | 切り替えが必要なスタイルは CSS クラスで管理 |
| ✅ Tailwind クラスの競合確認 | `whitespace-nowrap` 等は独自クラスに移管 |
| ✅ テーブル識別クラス | `rpt-tbl-planned` / `rpt-tbl-trouble` でテーブルを識別して個別制御 |

---

## 10. Playwright による GAS Web アプリのテスト

→ **`PLAYWRIGHT_RULES.md`** を参照。GAS 特有の iframe 構造・`networkidle` の使い分けを含む。

GAS Web アプリ（`...exec` URL）では `waitUntil: 'networkidle'` が有効。  
Google スプレッドシート（`docs.google.com/...`）では **`'load'`** を使う（常時 Ajax 通信があるため）。

---

## 11. よくあるミスと対処法（クイックリファレンス）

| ミス | 症状 | 正しい対処 |
|-----|------|----------|
| HTML 内に `<meta viewport>` を書く | モバイルで CSS が効かない | `doGet()` で `addMetaTag()` を使う |
| 列番号をハードコード | 列変更時に修正漏れ | `COL` 定数で管理 |
| `<?= ?>` で HTML を出力 | バッジが壊れる | `<?!= ?>` を使う |
| デプロイ後に変更が反映されない | 古い画面のまま | 新バージョンとして再デプロイ |
| セル単位でループ | 極端に遅い | `getValues()` 一括取得 |
| シークレットをソースに直書き | セキュリティリスク | Script Properties に移す |
| ALLOWALL を無条件に設定 | クリックジャックリスク | 埋め込み不要なら省略 |
