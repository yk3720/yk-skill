# GAS — パフォーマンス · データ処理（L3 参照）

**SSOT:** 本ファイル · **索引:** [`GAS_RULES.md`](../GAS_RULES.md) §7 · §8
**最終更新:** 2026-06-27（P14d · L1 から分割）

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
if (!lock.tryLock(5000)) {
  throw new Error('ロック取得に失敗（同時書き込みが競合）');
}
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
