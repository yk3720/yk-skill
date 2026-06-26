# GAS — データ設計（L3 参照）

**SSOT:** 本ファイル · **索引:** [`GAS_RULES.md`](../GAS_RULES.md) §3
**最終更新:** 2026-06-27（P14d · L1 から分割）

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
