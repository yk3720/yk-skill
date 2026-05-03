# GAS 設計ルール
## Google Apps Script Web アプリ開発 — Design & Development Rules v2

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

## 1. GAS HTML Service の制約と必須対応

Google Apps Script の HTML テンプレートは通常の Web ブラウザとは異なる環境で動作する。  
以下の制約を必ず理解した上で実装すること。

### 1-1. `<meta viewport>` は HTML ファイル内では**無効**

> **GAS の HTML ファイル内に書いた `<meta name="viewport">` タグは GAS によって無視される。**  
> — [Google Apps Script 公式ドキュメント: HTML Service Restrictions](https://developers.google.com/apps-script/guides/html/restrictions)

```html
<!-- ❌ GAS HTML ファイル内での記述 — 無視される -->
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

#### 正しい対応：`doGet()` 内で `addMetaTag()` を使う

```javascript
// ✅ GAS コード側（.gs ファイル）で指定する
function doGet() {
  return HtmlService.createTemplateFromFile('Report')
    .evaluate()
    .setTitle('タイトル')
    .addMetaTag('viewport', 'width=device-width, initial-scale=1')
    // ALLOWALL は埋め込み要件がある場合のみ。不要なら省略（デフォルトは DENY でより安全）
    .setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL);
}
```

> **`setXFrameOptionsMode(ALLOWALL)` のリスク**：クリックジャック攻撃の対象になりやすい。  
> 他サイトへの埋め込みが不要な場合は省略すること（デフォルトは DENY）。

#### この設定がないと発生する問題

| 症状 | 原因 |
|------|------|
| モバイルで CSS メディアクエリが効かない | ブラウザが画面幅を約 980px（PC デフォルト）と認識する |
| `@media (max-width: 639px)` が発火しない | 実際の幅は 390px なのにビューポートが 980px と判定される |
| `window.innerWidth` が 980 前後を返す | viewport 未設定によるブラウザのデフォルト動作 |

---

### 1-2. CSS の管理方針：インラインスタイルを避ける

**インラインスタイル（`style="..."` 属性）は CSS メディアクエリで上書きできない**（`!important` なしの場合）。

```html
<!-- ❌ インラインスタイル — メディアクエリで上書き不可 -->
<table style="min-width: 900px;">

<!-- ✅ CSS クラスで管理 — メディアクエリで確実に上書き可能 -->
<table class="rpt-tbl rpt-tbl-planned">
```

```css
.rpt-tbl-planned { min-width: 900px; }

@media (max-width: 639px) {
  .rpt-tbl-planned { min-width: 500px; }
}
```

---

### 1-3. Tailwind CDN との共存ルール

Tailwind Play CDN は JavaScript で動作し、`<style>` ブロックよりも**後からスタイルを DOM に注入**する場合がある。  
`whitespace-nowrap` 等の Tailwind クラスが独自 CSS クラスを上書きするケースに注意。

**解決方法：** Tailwind クラスを HTML から削除し、該当スタイルを独自 CSS クラスに移管する。

```css
.td-dev { color: var(--c-t2); white-space: nowrap; }
@media (max-width: 639px) {
  .td-dev { white-space: normal; }
}
```

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

## 3. データ設計ルール

### 3-1. 列インデックスは定数で管理する

```javascript
// ✅ 定数管理
const COL = {
  NO:         0,  // A
  TYPE:       1,  // B
  DEVICE:     2,  // C
  SUBJECT:    3,  // D
  STATUS:     9,  // J
  PRIORITY:   10, // K
};

// ❌ ハードコードは禁止
const status = row[9];
```

### 3-2. ステータス・種別の固定値は定数で管理する

スプレッドシートの入力規則とコード・HTML の値は**必ず一致させる**。

```javascript
const STATUS = {
  DONE:        '完了',
  IN_PROGRESS: '対応中',
  PENDING:     '確認中',
  NOT_REPORTED:'未報告',
};
const CATEGORY = {
  PLANNED: '定期作業',
  TROUBLE: '不具合',
  SPECIAL: '特記事項',
};
```

---

## 4. シート・ファイル管理ルール

### 4-1. シート名はスクリプトプロパティで管理する

```javascript
const SHEET_NAME = PropertiesService.getScriptProperties()
  .getProperty('SHEET_NAME') || '入力フォーム';
```

### 4-2. スクリプトプロパティ・シークレット管理

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

## 7. パフォーマンスルール

### 7-1. スプレッドシート I/O はバッチ処理する

**セル単位のループは禁止レベルで遅い。必ず `getValues()` / `setValues()` で二次元配列を一括処理する。**

```javascript
// ❌ セル単位ループ（数百行で数十秒かかる）
for (let i = 2; i <= lastRow; i++) {
  const val = sheet.getRange(i, 1).getValue();
}

// ✅ 一括読み込み（数百行でも 1 回のAPIコール）
const data = sheet.getRange(2, 1, lastRow - 1, colCount).getValues();
```

### 7-2. 6 分制限を超える処理は分割する

単一の実行で完結しない場合はトリガーで続きから再開する設計にする。  
途中経過は `PropertiesService` やシートに保存する。

### 7-3. CacheService で頻繁に読む値をキャッシュする

```javascript
const cache = CacheService.getScriptCache();
const cached = cache.get('summary');
if (cached) return JSON.parse(cached);

const data = /* 重い計算 */;
cache.put('summary', JSON.stringify(data), 300); // 5 分キャッシュ
return data;
```

### 7-4. 同時書き込みは LockService で保護する

```javascript
const lock = LockService.getScriptLock();
lock.tryLock(5000); // 最大 5 秒待機
try {
  // スプレッドシートへの書き込み
} finally {
  lock.releaseLock();
}
```

---

## 8. データ処理ルール

### 8-1. セル値は必ず `trim()` で正規化する

```javascript
function norm_(v) {
  return v != null ? String(v).trim() : '';
}
```

### 8-2. 日付はサーバー側でタイムゾーンを指定してフォーマットする

```javascript
// ✅ GAS サーバー側でフォーマット（Asia/Tokyo は appsscript.json の timeZone と揃える）
function formatDate(d) {
  if (!d || d === '') return '';
  if (d instanceof Date) return Utilities.formatDate(d, 'Asia/Tokyo', 'yyyy/MM/dd');
  return String(d);
}
```

### 8-3. 数値の上限クランプ

```javascript
const safeCur = Math.min(row.current, row.total);
const pct = (row.total > 0) ? Math.round(safeCur / row.total * 100) : null;
```

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
