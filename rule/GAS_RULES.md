# GAS 設計ルール
## Google Apps Script Web アプリ開発 — Design & Development Rules v1

---

## 1. GAS HTML Service の制約と必須対応

Google Apps Script の HTML テンプレートは通常の Web ブラウザとは異なる環境で動作する。  
以下の制約を必ず理解した上で実装すること。

### 1-1. `<meta viewport>` は HTML ファイル内では**無効**

> **GAS の HTML ファイル内に書いた `<meta name="viewport">` タグは GAS によって無視される。**  
> — [Google Apps Script 公式ドキュメント: HTML Service Restrictions](https://developers.google.com/apps-script/guides/html/restrictions)

HTML ファイル内に以下を書いても**モバイルブラウザには一切効果がない**：

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
    .addMetaTag('viewport', 'width=device-width, initial-scale=1')  // ← 必須
    .setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL);
}
```

#### この設定がないと発生する問題

| 症状 | 原因 |
|------|------|
| モバイルで CSS メディアクエリが効かない | ブラウザが画面幅を約 980px（PC デフォルト）と認識する |
| `@media (max-width: 639px)` が発火しない | 実際の幅は 390px なのにビューポートが 980px と判定される |
| `window.innerWidth` が 980 前後を返す | viewport 未設定によるブラウザのデフォルト動作 |
| テキストが極端に小さく表示される | 全体が縮小表示されるため |

#### HTML 内の `<meta viewport>` を残す理由

HTML ファイルをブラウザで**直接開いて動作確認**する際には機能するため、  
ローカル確認用として残しておいてもよい（GAS 環境では無視されるだけで害はない）。

---

### 1-2. CSS メディアクエリの動作条件

`addMetaTag()` による viewport 設定が完了すれば、**CSS メディアクエリは通常通り動作する**。

```css
/* ✅ addMetaTag 設定後はこれが正しく機能する */
@media (max-width: 639px) {
  /* モバイル向けスタイル */
}
```

JavaScript による `window.innerWidth` 判定も同様に正しく動作する。  
ただし CSS メディアクエリの方が宣言的でシンプルなため、特別な理由がない限り CSS を優先する。

---

### 1-3. CSS の管理方針：インラインスタイルを避ける

**インラインスタイル（`style="..."` 属性）は CSS メディアクエリで上書きできない**（`!important` なしの場合）。  
モバイル対応など、環境によってスタイルを切り替える可能性がある要素には**インラインスタイルを使わない**。

```html
<!-- ❌ インラインスタイル — メディアクエリで上書き不可 -->
<table style="min-width: 900px;">
<td style="max-width: 200px;">

<!-- ✅ CSS クラスで管理 — メディアクエリで確実に上書き可能 -->
<table class="rpt-tbl rpt-tbl-planned">
<td class="td-txt">
```

```css
/* CSS ファイル側で定義し、メディアクエリで上書き */
.rpt-tbl-planned { min-width: 900px; }
.td-txt          { max-width: 200px; }

@media (max-width: 639px) {
  .rpt-tbl-planned { min-width: 500px; }
  .td-txt          { max-width: none; min-width: 160px; }
}
```

---

### 1-4. Tailwind CDN との共存ルール

Tailwind Play CDN（`<script src="https://cdn.tailwindcss.com">`）は JavaScript で動作し、  
HTML `<style>` ブロックよりも**後からスタイルを DOM に注入**する場合がある。

このため、`<style>` ブロック内のルールが Tailwind のユーティリティクラスに負けるケースがある。

```html
<!-- ❌ Tailwind クラスと独自 CSS クラスが競合するパターン -->
<td class="td-dev whitespace-nowrap">
<!--
  whitespace-nowrap (Tailwind) が後から注入されると
  .td-dev { white-space: normal } が上書きされる
-->
```

**解決方法：** Tailwind クラスを HTML から削除し、該当スタイルを独自 CSS クラスに移管する。

```html
<!-- ✅ 修正後 -->
<td class="td-dev">
```

```css
/* CSS ファイル側で管理 */
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

クライアント側 JavaScript に GAS データを渡す際、`</script>` タグが含まれると  
スクリプトが意図せず終了するため、必ずエスケープする。

```html
<script>
var PLANNED_DATA = <?!= JSON.stringify(planned).replace(/<\//g, '<\\/') ?>;
</script>
```

### 2-3. テンプレートタグは絶対に削除・変形しない

`<? ?>` タグは GAS のサーバー側テンプレートエンジンが処理する。  
HTML エディタや整形ツールがこれらを壊す場合があるため、**手動編集時は特に注意**する。

---

## 3. データ設計ルール

### 3-1. 列インデックスは定数で管理する

スプレッドシートの列番号をコード内に直接書くと、列を追加・移動した際に全箇所の修正が必要になる。  
**必ず定数オブジェクトで管理する。**

```javascript
// ✅ 定数管理
const COL = {
  NO:         0,  // A
  TYPE:       1,  // B
  DEVICE:     2,  // C
  SUBJECT:    3,  // D
  SITUATION:  4,  // E
  RESULT:     5,  // F
  REGISTERED: 6,  // G
  START:      7,  // H
  DEADLINE:   8,  // I
  STATUS:     9,  // J
  PRIORITY:   10, // K
  CURRENT:    11, // L
  TOTAL:      12, // M
};

// ❌ ハードコードは禁止
const status = row[9];  // 9 が何の列か分からない
```

### 3-2. ステータス・種別の固定値は定数で管理する

スプレッドシートの入力規則（固定値）と GAS コード・HTML の対応値は**必ず一致させる**。  
値が変わった際に修正漏れが出ないよう、GAS コード内の定数として一元管理する。

```javascript
const STATUS = {
  DONE:        '完了',
  DONE_ALT:    '済',      // スプレッドシートの入力規則にない場合は使用しない
  IN_PROGRESS: '対応中',
  PENDING:     '確認中',
  NOT_REPORTED:'未報告',
};
const CATEGORY = {
  PLANNED: '定期作業',
  TROUBLE: '不具合',
  SPECIAL: '特記事項',  // 「特機事項」は誤記
};
```

### 3-3. スプレッドシート入力規則との整合性チェック

HTML のバッジ関数（`statusBadge`, `categoryBadge`, `priorityBadge`）が扱う値は、  
スプレッドシートの**固定入力規則の値と完全に一致**させること。

| スプレッドシート固定値 | HTML バッジ関数のキー |
|--------------------|--------------------|
| 定期作業 / 不具合 / 特記事項 | `categoryBadge()` のマップキー |
| 完了 / 対応中 / 確認中 / 未報告 | `statusBadge()` のマップキー |
| 高 / 中 / 低 | `priorityBadge()` のマップキー |

---

## 4. シート・ファイル管理ルール

### 4-1. シート名はスクリプトプロパティで管理する

シート名をコード内にハードコードすると、シート名変更時に修正が必要になる。  
**スクリプトプロパティ経由で設定し、デフォルト値は実運用のシート名に合わせる。**

```javascript
// ✅ スクリプトプロパティ優先、フォールバックはデフォルトシート名
const SHEET_NAME = PropertiesService.getScriptProperties()
  .getProperty('SHEET_NAME') || '入力フォーム';
```

### 4-2. スクリプトプロパティの一覧

プロジェクトで使用するスクリプトプロパティは必ずコメントで記載する。

```javascript
// 使用するスクリプトプロパティ一覧
// SPREADSHEET_ID : 対象スプレッドシートのID
// SHEET_NAME     : データ入力シート名（デフォルト: '入力フォーム'）
// LINE_TOKEN     : LINE Messaging API のチャンネルアクセストークン
// LINE_CHANNEL_SECRET : LINE Webhook 署名検証用シークレット
// LINE_USER_ID   : 通知先の LINE ユーザーID（Webhook で自動登録）
// REPORT_URL     : GAS Web アプリの公開 URL
```

---

## 5. デプロイルール

### 5-1. 変更を反映するには「新しいバージョン」として再デプロイが必要

GAS Web アプリは**デプロイしたバージョン**を提供する。  
コードを保存しても、既存のデプロイ URL には自動で反映されない。

```
変更手順:
1. コードを編集・保存
2. 「デプロイ」→「デプロイを管理」
3. 既存のデプロイを選択→「編集」→「バージョン: 新しいバージョン」
4. デプロイ
```

> **単なる上書き保存だけでは既存の URL に変更が反映されない。**

### 5-2. テスト関数を用意する

デプロイ前に `testReport()` 等のテスト関数でデータ取得・集計の動作を確認する。

```javascript
function testReport() {
  const rows    = getDataRows_();
  const planned = buildPlanned_(rows);
  const trouble = buildTrouble_(rows);
  const summary = buildSummary_(planned, trouble);
  Logger.log('サマリー: ' + JSON.stringify(summary));
  Logger.log('定期: ' + planned.length + '件 / トラブル: ' + trouble.length + '件');
}
```

---

## 6. セキュリティルール

### 6-1. LINE Webhook は署名検証を必ず実施する

```javascript
// HMAC-SHA256 でリクエストの正当性を検証
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

`doGet()` でエラーが発生した際、エラーメッセージをそのまま HTML に出力しない。  
`<` `>` `&` を必ずエスケープしてから出力する。

```javascript
const safeMsg = String(err.message)
  .replace(/&/g, '&amp;')
  .replace(/</g, '&lt;')
  .replace(/>/g, '&gt;');
```

---

## 7. データ処理ルール

### 7-1. セル値は必ず `trim()` で正規化する

スプレッドシートのセルには意図しない前後スペースが入ることがある。  
文字列の比較・フィルタリング前に必ず正規化する。

```javascript
function norm_(v) {
  return v != null ? String(v).trim() : '';
}
```

### 7-2. 日付はサーバー側でタイムゾーンを指定してフォーマットする

JavaScript の `new Date()` はクライアント（ブラウザ）のタイムゾーンに依存する。  
**日付のフォーマットは GAS サーバー側（Asia/Tokyo 指定）で行う**。

```javascript
// ✅ GAS サーバー側でフォーマット
function formatDate(d) {
  if (!d || d === '') return '';
  if (d instanceof Date) return Utilities.formatDate(d, 'Asia/Tokyo', 'yyyy/MM/dd');
  return String(d);
}
```

### 7-3. 数値の上限クランプ

「完了数 > 計画数」など、データの不整合が UI を壊さないようクランプ処理を行う。

```javascript
const safeCur = Math.min(row.current, row.total);
const pct = (row.total > 0) ? Math.round(safeCur / row.total * 100) : null;
```

---

## 8. モバイル対応チェックリスト

GAS Web アプリのモバイル対応実装時に必ず確認する項目。

| チェック項目 | 対応方法 |
|------------|---------|
| ✅ viewport 設定 | `doGet()` 内で `addMetaTag('viewport', 'width=device-width, initial-scale=1')` |
| ✅ CSS メディアクエリ | `@media (max-width: 639px)` で上書き |
| ✅ インラインスタイル排除 | 切り替えが必要なスタイルは CSS クラスで管理 |
| ✅ Tailwind クラスの競合確認 | `whitespace-nowrap` 等は独自クラスに移管 |
| ✅ テーブル識別クラス | `rpt-tbl-planned` / `rpt-tbl-trouble` でテーブルを識別して個別制御 |
| ✅ 動作確認の方法 | 非表示にした列（No・優先度等）が消えていることでメディアクエリの発火を確認 |

---

## 9. よくあるミスと対処法

| ミス | 症状 | 正しい対処 |
|-----|------|----------|
| HTML 内に `<meta viewport>` を書く | モバイルで CSS が効かない | `doGet()` で `addMetaTag()` を使う |
| 列番号をハードコード | 列変更時に修正漏れが発生 | `COL` 定数で管理 |
| 種別・ステータスの文言ミス | バッジが正しく表示されない / フィルターが効かない | 入力規則の固定値と完全一致させる |
| デプロイ後に変更が反映されない | 古いバージョンが表示され続ける | 新しいバージョンとして再デプロイ |
| `<?= ?>` で HTML を出力 | `<` `>` がエスケープされてバッジが壊れる | `<?!= ?>` を使う |
| スプレッドシート名をハードコード | シート名変更時にエラー | スクリプトプロパティで管理 |
| インラインスタイルを CSS で上書きしようとする | メディアクエリが効かない | インラインスタイルを CSS クラスに移管 |
