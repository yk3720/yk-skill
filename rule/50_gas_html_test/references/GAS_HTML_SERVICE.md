# GAS — HTML Service（L3 参照）

**SSOT:** 本ファイル · **索引:** [`GAS_RULES.md`](../GAS_RULES.md) §1
**最終更新:** 2026-06-27（P14d · L1 から分割）

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

**`XFrameOptionsMode`:** 省略時は **DENY**（より安全）。**iframe 埋め込みが必要なときだけ** `ALLOWALL` を設定する。

```javascript
// ✅ 通常（単体で開く・埋め込み不要）— setXFrameOptionsMode は書かない
function doGet() {
  return HtmlService.createTemplateFromFile('Report')
    .evaluate()
    .setTitle('タイトル')
    .addMetaTag('viewport', 'width=device-width, initial-scale=1');
}
```

```javascript
// ✅ iframe 埋め込みが必要なときだけ ALLOWALL
function doGet() {
  const output = HtmlService.createTemplateFromFile('Report')
    .evaluate()
    .setTitle('タイトル')
    .addMetaTag('viewport', 'width=device-width, initial-scale=1');
  output.setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL);
  return output;
}
```

#### ⚠️ 「接続が拒否されました」エラーの注意点
GAS Web アプリを直接開いているのにこのエラーが出る場合、以下の原因が考えられる。
1. **ファイル名の不一致**: `createTemplateFromFile('FileName')` の引数が GAS エディタ上のファイル名と 1 文字でも違うと、GAS は内部エラーを起こし、ブラウザ側で「接続拒否」として表示されることがある。
2. **メソッドチェーンの失敗**: `.evaluate().setXFrameOptionsMode(...)` のように繋げて書くと設定が反映されないケースがある。一度変数に代入してから設定を適用すると確実。

```javascript
// ✅ より確実な書き方（埋め込み不要 — ALLOWALL は付けない）
const output = HtmlService.createTemplateFromFile('Report').evaluate();
output.setTitle('タイトル');
output.addMetaTag('viewport', 'width=device-width, initial-scale=1');
return output;
```

```javascript
// ❌ 悪い例：埋め込み不要なのに ALLOWALL をデフォルトで付ける
const output = HtmlService.createTemplateFromFile('Report').evaluate();
output.setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL);
return output;
```

#### この設定がないと発生する問題

| 症状 | 原因 |
|------|------|
| モバイルで CSS メディアクエリが効かない | ブラウザが画面幅を約 980px（PC デフォルト）と認識する |
| `@media (max-width: 639px)` が発火しない | 実際の幅は 390px なのにビューポートが 980px と判定される |
| `window.innerWidth` が 980 前後を返す | viewport 未設定によるブラウザのデフォルト動作 |
| **接続が拒否されました** | `XFrameOptionsMode` の設定不備、またはファイル名指定ミスによる内部エラー |

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
