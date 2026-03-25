# 模範解答パターン

## 成功する図解の構造

```
1. ヘッダー（紺×スカイブルーのグラデーション）
   └─ カテゴリバッジ（「プログラミング」「ネットワーク」「AI」等）
   └─ タイトル + サブタイトル

2. 一言サマリー（概要カード）
   └─ 「ひとことで言えば：〇〇とは△△である」
   └─ 存在意義（Why）を先に示す

3. まず理解する3つ
   └─ 絞り込んだ最重要ポイント
   └─ 重要度バッジ（必須/推奨/参考）

4. 用語解説ボックス（初出時）
   └─ 制御・FA経験に紐づくたとえ付き

5. 詳細セクション群
   └─ 概念図またはフローチャート
   └─ たとえ話ボックス（3つ以上）
   └─ コード例（必要な場合）

6. 関連トピック
   └─ 「次に学ぶと良いもの」を3〜5個
   └─ なぜ関連するかを一言で説明

7. 参考文献・URL
   └─ クリッカブルなリンク一覧
   └─ 何のサイトかを一言添える

8. 目次（フローティング・デスクトップのみ）
```

---

## 「まず理解する3つ」の書き方

```html
<div class="section-card" id="basics">
  <div class="flex items-center gap-3 mb-6">
    <div class="w-12 h-12 bg-gradient-to-br from-sky-500 to-blue-600 rounded-xl flex items-center justify-center">
      <i data-lucide="star" class="w-6 h-6 text-white"></i>
    </div>
    <div>
      <h2 class="text-2xl font-bold text-gray-800">まず理解する3つ</h2>
      <p class="text-gray-500">最初はこれだけでOK</p>
    </div>
  </div>

  <div class="grid gap-4">
    <!-- 1つ目 -->
    <div class="flex items-start gap-4 p-4 bg-gradient-to-r from-red-50 to-red-100 rounded-xl border-l-4 border-red-500">
      <div class="w-10 h-10 bg-red-500 text-white rounded-full flex items-center justify-center font-bold text-lg flex-shrink-0">1</div>
      <div>
        <div class="flex items-center gap-2 mb-1">
          <span class="font-bold text-lg text-gray-800">【ポイント1の名前】</span>
          <span class="badge-essential">必須</span>
        </div>
        <p class="text-gray-600">【ポイント1の説明。制御経験者にわかる言葉で一言。】</p>
      </div>
    </div>

    <!-- 2つ目 -->
    <div class="flex items-start gap-4 p-4 bg-gradient-to-r from-blue-50 to-blue-100 rounded-xl border-l-4 border-blue-500">
      <div class="w-10 h-10 bg-blue-500 text-white rounded-full flex items-center justify-center font-bold text-lg flex-shrink-0">2</div>
      <div>
        <div class="flex items-center gap-2 mb-1">
          <span class="font-bold text-lg text-gray-800">【ポイント2の名前】</span>
          <span class="badge-recommended">推奨</span>
        </div>
        <p class="text-gray-600">【ポイント2の説明。】</p>
      </div>
    </div>

    <!-- 3つ目 -->
    <div class="flex items-start gap-4 p-4 bg-gradient-to-r from-emerald-50 to-emerald-100 rounded-xl border-l-4 border-emerald-500">
      <div class="w-10 h-10 bg-emerald-500 text-white rounded-full flex items-center justify-center font-bold text-lg flex-shrink-0">3</div>
      <div>
        <div class="flex items-center gap-2 mb-1">
          <span class="font-bold text-lg text-gray-800">【ポイント3の名前】</span>
          <span class="badge-optional">参考</span>
        </div>
        <p class="text-gray-600">【ポイント3の説明。】</p>
      </div>
    </div>
  </div>
</div>
```

---

## たとえ話ボックスの展開パターン

### パターン1: PLCのシーケンスとの対比

STコードや状態管理の説明に使う。

```html
<div class="bg-gradient-to-r from-sky-50 to-blue-50 p-6 rounded-xl border border-sky-200 my-6">
  <div class="flex items-center gap-2 mb-3">
    <i data-lucide="cpu" class="w-6 h-6 text-sky-600"></i>
    <span class="font-bold text-sky-800">制御で考えると：PLCのステップシーケンスとの対比</span>
  </div>
  <div class="space-y-3 text-gray-700">
    <p>PLCのステップシーケンス（STEP管理）を思い浮かべてください。「現在のSTEPに応じて処理を切り替える」あの仕組みと同じ発想です。</p>
    <div class="grid grid-cols-2 gap-4 my-4">
      <div class="bg-sky-100 p-3 rounded-lg text-center">
        <i data-lucide="cpu" class="w-8 h-8 text-sky-600 mx-auto mb-2"></i>
        <p class="font-bold text-sky-800">PLCのSTEP管理</p>
        <p class="text-sm text-gray-600 mt-1">現在STEPに応じて処理を切り替える</p>
      </div>
      <div class="bg-blue-100 p-3 rounded-lg text-center">
        <i data-lucide="git-branch" class="w-8 h-8 text-blue-600 mx-auto mb-2"></i>
        <p class="font-bold text-blue-800">【対比する技術概念】</p>
        <p class="text-sm text-gray-600 mt-1">【どう対応するか】</p>
      </div>
    </div>
    <ul class="list-disc list-inside space-y-1 ml-2">
      <li><strong>PLCのSTEP番号</strong> → 【対応する概念】</li>
      <li><strong>STEP移行条件</strong> → 【対応する概念】</li>
      <li><strong>STEP内の処理</strong> → 【対応する概念】</li>
    </ul>
  </div>
</div>
```

### パターン2: センサー・シリンダとの対比

イベント駆動・トリガー系の説明に使う。

```html
<div class="bg-gradient-to-r from-amber-50 to-orange-50 p-6 rounded-xl border border-amber-200 my-6">
  <div class="flex items-center gap-2 mb-3">
    <i data-lucide="zap" class="w-6 h-6 text-amber-600"></i>
    <span class="font-bold text-amber-800">制御で考えると：センサーONでシリンダが動くあの仕組み</span>
  </div>
  <div class="space-y-3 text-gray-700">
    <p>光電センサーがONになると→電磁弁が切り替わり→シリンダが前進する。この「きっかけ→処理→結果」の流れと同じです。</p>
    <ul class="list-disc list-inside space-y-1 ml-2">
      <li><strong>センサーON（きっかけ）</strong> → 【対応するイベント・トリガー】</li>
      <li><strong>PLCのラダー処理（処理）</strong> → 【対応する処理】</li>
      <li><strong>シリンダ前進（結果）</strong> → 【対応するアウトプット】</li>
    </ul>
    <p class="text-sm bg-amber-100 p-3 rounded-lg">
      <strong>ポイント：</strong>センサーが来るまでPLCは何もしない。この「待ち→反応」がイベント駆動の本質です。
    </p>
  </div>
</div>
```

### パターン3: 工程チェックシートとの対比

アルゴリズム・処理フロー系の説明に使う。

```html
<div class="bg-gradient-to-r from-emerald-50 to-green-50 p-6 rounded-xl border border-emerald-200 my-6">
  <div class="flex items-center gap-2 mb-3">
    <i data-lucide="clipboard-list" class="w-6 h-6 text-emerald-600"></i>
    <span class="font-bold text-emerald-800">制御で考えると：製造工程チェックシートとの対比</span>
  </div>
  <div class="space-y-3 text-gray-700">
    <p>工程チェックシートと同じ構造です。「条件を確認→次の工程へ」を繰り返す。</p>
    <div class="bg-white border border-gray-300 rounded-lg p-4 font-mono text-sm">
      <p class="font-bold mb-2 text-gray-700">□ 工程チェックシート（制御フローのたとえ）</p>
      <p>① 前提条件を確認 → OKなら②へ</p>
      <p>② メイン処理を実行 → 完了を確認 → ③へ</p>
      <p>③ 後処理・記録 → 完了 → ①に戻る</p>
    </div>
    <p>【対比する技術】の<strong>【キーワード】</strong>は、この「○○ならば△△する」という条件分岐と全く同じ発想です。</p>
  </div>
</div>
```

---

## 参考文献セクションの成功パターン

```html
<div class="section-card" id="references">
  <div class="flex items-center gap-3 mb-6">
    <div class="w-12 h-12 bg-gray-100 rounded-xl flex items-center justify-center">
      <i data-lucide="book-open" class="w-6 h-6 text-gray-600"></i>
    </div>
    <div>
      <h2 class="text-2xl font-bold text-gray-800">参考文献・公式資料</h2>
      <p class="text-gray-500">さらに詳しく知りたい場合はこちら</p>
    </div>
  </div>
  <p class="text-gray-600 mb-4">この図解を作成するにあたり参照した資料です。疑問が残った部分はこちらで確認できます。</p>
  <div class="space-y-3">
    <a href="https://example.com/official" target="_blank" rel="noopener" class="ref-link">
      <i data-lucide="external-link" class="w-4 h-4 flex-shrink-0 text-sky-500"></i>
      <div>
        <div class="font-medium text-gray-800">公式ドキュメント（英語）</div>
        <div class="text-xs text-gray-500">最も正確な情報源。仕様を確認したいときはここ</div>
      </div>
    </a>
    <a href="https://example.com/japanese-intro" target="_blank" rel="noopener" class="ref-link">
      <i data-lucide="external-link" class="w-4 h-4 flex-shrink-0 text-sky-500"></i>
      <div>
        <div class="font-medium text-gray-800">日本語入門記事</div>
        <div class="text-xs text-gray-500">公式が難しいと感じたらここから</div>
      </div>
    </a>
    <a href="https://example.com/youtube" target="_blank" rel="noopener" class="ref-link">
      <i data-lucide="external-link" class="w-4 h-4 flex-shrink-0 text-sky-500"></i>
      <div>
        <div class="font-medium text-gray-800">YouTube解説動画</div>
        <div class="text-xs text-gray-500">動画で視覚的に理解したい場合</div>
      </div>
    </a>
  </div>
</div>
```

---

## 関連トピックセクションの成功パターン

```html
<div class="section-card" id="related">
  <div class="flex items-center gap-3 mb-6">
    <div class="w-12 h-12 bg-emerald-100 rounded-xl flex items-center justify-center">
      <i data-lucide="compass" class="w-6 h-6 text-emerald-600"></i>
    </div>
    <div>
      <h2 class="text-2xl font-bold text-gray-800">次に学ぶと良いもの</h2>
      <p class="text-gray-500">この知識を起点に広げていこう</p>
    </div>
  </div>
  <div class="grid sm:grid-cols-2 gap-4">
    <div class="flex items-start gap-3 p-4 bg-emerald-50 rounded-xl border border-emerald-200">
      <i data-lucide="arrow-right-circle" class="w-6 h-6 text-emerald-600 flex-shrink-0 mt-0.5"></i>
      <div>
        <div class="font-bold text-gray-800">【関連トピック1】</div>
        <div class="text-sm text-gray-600 mt-1">【この技術を理解すると自然に気になる理由を一言で】</div>
      </div>
    </div>
    <div class="flex items-start gap-3 p-4 bg-sky-50 rounded-xl border border-sky-200">
      <i data-lucide="arrow-right-circle" class="w-6 h-6 text-sky-600 flex-shrink-0 mt-0.5"></i>
      <div>
        <div class="font-bold text-gray-800">【関連トピック2】</div>
        <div class="text-sm text-gray-600 mt-1">【この技術を理解すると自然に気になる理由を一言で】</div>
      </div>
    </div>
    <div class="flex items-start gap-3 p-4 bg-amber-50 rounded-xl border border-amber-200">
      <i data-lucide="arrow-right-circle" class="w-6 h-6 text-amber-600 flex-shrink-0 mt-0.5"></i>
      <div>
        <div class="font-bold text-gray-800">【関連トピック3】</div>
        <div class="text-sm text-gray-600 mt-1">【この技術を理解すると自然に気になる理由を一言で】</div>
      </div>
    </div>
  </div>
</div>
```

---

## 品質チェックリスト

作成後、以下を確認：

### 内容の品質

- [ ] 冒頭に「ひとことで言えば」のサマリーがある
- [ ] 「まず理解する3つ」がある
- [ ] 全ての技術用語に用語解説ボックスがある（初出時）
- [ ] たとえ話が3つ以上ある（制御・FA経験に紐づくものを優先）
- [ ] コード例の前に「このコードがやること」がある（日本語）
- [ ] 参考文献URLがクリッカブルなリンクで末尾にある
- [ ] 関連トピックが末尾にあり、「なぜ関連するか」が一言添えられている

### デザイン

- [ ] Lucide iconのみ使用（絵文字なし）
- [ ] フローチャートまたは概念図がある
- [ ] スマホで読みやすい（レスポンシブ）
- [ ] 目次がフローティング表示される（デスクトップ）
- [ ] 紺×スカイブルーのカラースキームが統一されている
