# HTML構造ガイド

## 基本テンプレート

```html
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>【図解タイトル】- Techmap</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://unpkg.com/lucide@latest"></script>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    :root {
      --techmap-primary: #1e3a5f;
      --techmap-accent: #0ea5e9;
      --techmap-gradient: linear-gradient(135deg, #1e3a5f 0%, #0ea5e9 100%);
    }

    body {
      font-family: 'Noto Sans JP', 'Inter', sans-serif;
    }

    /* ヘッダーグラデーション */
    .header-gradient {
      background: var(--techmap-gradient);
    }

    /* セクションカード */
    .section-card {
      background: white;
      border-radius: 1rem;
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
      padding: 2rem;
      margin-bottom: 2rem;
    }

    /* 用語解説ボックス */
    .term-explain {
      background: linear-gradient(135deg, #e0f2fe 0%, #bae6fd 100%);
      border-left: 4px solid #0ea5e9;
      padding: 1.5rem;
      border-radius: 0.75rem;
      margin: 1.5rem 0;
    }
    .term-word {
      color: #0369a1;
    }

    /* 重要度バッジ */
    .badge-essential {
      background: linear-gradient(135deg, #dc2626 0%, #ef4444 100%);
      color: white;
      padding: 0.25rem 0.75rem;
      border-radius: 9999px;
      font-size: 0.875rem;
      font-weight: 600;
    }
    .badge-recommended {
      background: linear-gradient(135deg, #2563eb 0%, #3b82f6 100%);
      color: white;
      padding: 0.25rem 0.75rem;
      border-radius: 9999px;
      font-size: 0.875rem;
      font-weight: 600;
    }
    .badge-optional {
      background: linear-gradient(135deg, #6b7280 0%, #9ca3af 100%);
      color: white;
      padding: 0.25rem 0.75rem;
      border-radius: 9999px;
      font-size: 0.875rem;
      font-weight: 600;
    }

    /* コードブロック */
    .code-block {
      background: #1e293b;
      color: #e2e8f0;
      padding: 1.5rem;
      border-radius: 0.75rem;
      overflow-x: auto;
      font-family: 'Consolas', 'Fira Code', monospace;
      font-size: 0.875rem;
      line-height: 1.7;
    }

    /* 参考文献リンク */
    .ref-link {
      display: flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0.75rem 1rem;
      background: #f8fafc;
      border: 1px solid #e2e8f0;
      border-radius: 0.5rem;
      text-decoration: none;
      color: #0ea5e9;
      transition: background 0.15s;
    }
    .ref-link:hover {
      background: #e0f2fe;
    }

    /* 目次 */
    .toc {
      position: fixed;
      right: 2rem;
      top: 50%;
      transform: translateY(-50%);
      background: white;
      padding: 1rem;
      border-radius: 0.75rem;
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
      max-height: 80vh;
      overflow-y: auto;
      z-index: 50;
      min-width: 160px;
    }
    @media (max-width: 1280px) {
      .toc { display: none; }
    }

    /* PDFボタン */
    .pdf-btn {
      position: fixed;
      bottom: 2rem;
      right: 2rem;
      background: var(--techmap-gradient);
      color: white;
      border: none;
      padding: 0.75rem 1.25rem;
      border-radius: 9999px;
      font-size: 0.875rem;
      font-weight: 600;
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 0.5rem;
      box-shadow: 0 4px 14px rgba(14, 165, 233, 0.4);
      transition: opacity 0.15s, transform 0.15s;
      z-index: 100;
    }
    .pdf-btn:hover {
      opacity: 0.9;
      transform: translateY(-2px);
    }

    /* 印刷時の設定 */
    @media print {
      .toc,
      .pdf-btn {
        display: none !important;
      }
      body {
        background: white;
      }
      .section-card {
        box-shadow: none;
        border: 1px solid #e2e8f0;
        break-inside: avoid;
        page-break-inside: avoid;
      }
      .header-gradient {
        -webkit-print-color-adjust: exact;
        print-color-adjust: exact;
      }
      a[href]::after {
        content: none;
      }
    }
  </style>
</head>
<body class="bg-gray-50">

  <!-- 目次（デスクトップ専用・フローティング） -->
  <nav class="toc">
    <p class="text-xs font-bold text-gray-500 uppercase tracking-wide mb-3">目次</p>
    <ul class="space-y-1 text-sm">
      <li><a href="#summary" class="text-gray-600 hover:text-sky-600">概要</a></li>
      <li><a href="#basics" class="text-gray-600 hover:text-sky-600">まず理解する3つ</a></li>
      <li><a href="#details" class="text-gray-600 hover:text-sky-600">詳細</a></li>
      <li><a href="#related" class="text-gray-600 hover:text-sky-600">関連トピック</a></li>
      <li><a href="#references" class="text-gray-600 hover:text-sky-600">参考文献</a></li>
    </ul>
  </nav>

  <!-- ヘッダー -->
  <header class="header-gradient text-white py-10">
    <div class="max-w-4xl mx-auto px-4">
      <div class="flex items-center gap-2 mb-3">
        <span class="text-xs bg-white/20 px-3 py-1 rounded-full font-medium tracking-wide">Techmap</span>
        <span class="text-xs bg-white/20 px-3 py-1 rounded-full font-medium">【カテゴリ】</span>
      </div>
      <h1 class="text-3xl md:text-4xl font-bold">【タイトル】</h1>
      <p class="mt-2 text-lg opacity-90">【サブタイトル】</p>
    </div>
  </header>

  <!-- メインコンテンツ -->
  <main class="max-w-4xl mx-auto px-4 py-8">

    <!-- 概要サマリー -->
    <section id="summary" class="section-card">
      <!-- ひとことで言えば -->
    </section>

    <!-- まず理解する3つ -->
    <section id="basics" class="section-card">
      <!-- 絞り込み3ポイント -->
    </section>

    <!-- 詳細セクション群 -->
    <section id="details">
      <!-- 各トピックのセクションカード -->
    </section>

    <!-- 関連トピック -->
    <section id="related" class="section-card">
      <!-- 次に学ぶと良いもの -->
    </section>

    <!-- 参考文献 -->
    <section id="references" class="section-card">
      <!-- クリッカブルなURLリスト -->
    </section>

  </main>

  <!-- PDFダウンロードボタン -->
  <button class="pdf-btn" onclick="window.print()">
    <i data-lucide="download" class="w-4 h-4"></i>
    PDFで保存
  </button>

  <script>
    lucide.createIcons();
  </script>
</body>
</html>
```

---

## ページ構成の順序

```
1. ヘッダー（紺×スカイブルーのグラデーション）
   └─ カテゴリバッジ（「プログラミング」「ネットワーク」等）
   └─ タイトル + サブタイトル

2. 一言サマリー（概要カード）
   └─ 「ひとことで言えば：〇〇とは△△である」
   └─ 存在意義・Whyを先に示す

3. まず理解する3つ
   └─ 絞り込んだ最重要ポイント
   └─ 重要度バッジ（必須/推奨/参考）

4. 用語解説ボックス
   └─ 初出の技術用語を全て解説（制御・FA寄りのたとえ付き）

5. 詳細セクション群
   └─ 概念図またはフローチャート
   └─ たとえ話ボックス（3つ以上）
   └─ コード例（必要な場合）

6. 関連トピック
   └─ 「次に学ぶと良いもの」を3〜5個
   └─ なぜ関連するかを一言で説明

7. 参考文献・URL
   └─ クリッカブルなリンク一覧
   └─ 何のサイトかを一言で添える

8. 目次（フローティング・デスクトップのみ）
```

---

## 用語解説ボックス

```html
<div class="term-explain">
  <div class="flex items-start gap-4">
    <i data-lucide="lightbulb" class="w-8 h-8 text-sky-500 flex-shrink-0"></i>
    <div>
      <div class="term-word text-xl font-bold">「〇〇」とは？</div>
      <div class="text-lg mt-2">
        難しそうな名前ですが、要は<span class="font-bold text-sky-700">「△△するもの」</span>のこと。<br>
        制御の世界でたとえると、<strong>□□と同じ発想</strong>です。
      </div>
    </div>
  </div>
</div>
```

---

## 一言サマリーボックス

```html
<div class="section-card" id="summary">
  <div class="flex items-center gap-3 mb-4">
    <div class="w-12 h-12 bg-sky-100 rounded-xl flex items-center justify-center">
      <i data-lucide="map" class="w-6 h-6 text-sky-600"></i>
    </div>
    <div>
      <h2 class="text-2xl font-bold text-gray-800">ひとことで言えば</h2>
      <p class="text-gray-500">まずここだけ押さえる</p>
    </div>
  </div>
  <div class="bg-gradient-to-r from-sky-50 to-blue-50 border border-sky-200 rounded-xl p-6">
    <p class="text-xl font-bold text-sky-900">【トピック名】とは、〇〇するための△△である。</p>
    <p class="mt-3 text-gray-700">【存在意義・Whyの説明。なぜこれが生まれたか。】</p>
  </div>
</div>
```

---

## 参考文献セクション

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
  <div class="space-y-3">
    <a href="https://example.com/docs" target="_blank" rel="noopener" class="ref-link">
      <i data-lucide="external-link" class="w-4 h-4 flex-shrink-0"></i>
      <div>
        <div class="font-medium">公式ドキュメント</div>
        <div class="text-xs text-gray-500">https://example.com/docs</div>
      </div>
    </a>
    <a href="https://example.com/tutorial" target="_blank" rel="noopener" class="ref-link">
      <i data-lucide="external-link" class="w-4 h-4 flex-shrink-0"></i>
      <div>
        <div class="font-medium">入門チュートリアル</div>
        <div class="text-xs text-gray-500">https://example.com/tutorial</div>
      </div>
    </a>
  </div>
</div>
```

---

## 関連トピックセクション

```html
<div class="section-card" id="related">
  <div class="flex items-center gap-3 mb-6">
    <div class="w-12 h-12 bg-emerald-100 rounded-xl flex items-center justify-center">
      <i data-lucide="compass" class="w-6 h-6 text-emerald-600"></i>
    </div>
    <div>
      <h2 class="text-2xl font-bold text-gray-800">次に学ぶと良いもの</h2>
      <p class="text-gray-500">この知識の先にあるトピック</p>
    </div>
  </div>
  <div class="grid sm:grid-cols-2 gap-4">
    <div class="flex items-start gap-3 p-4 bg-emerald-50 rounded-xl border border-emerald-200">
      <i data-lucide="arrow-right-circle" class="w-6 h-6 text-emerald-600 flex-shrink-0 mt-0.5"></i>
      <div>
        <div class="font-bold text-gray-800">【関連トピック名】</div>
        <div class="text-sm text-gray-600 mt-1">【なぜ関連するかの一言説明】</div>
      </div>
    </div>
  </div>
</div>
```

---

## セクションヘッダーの書き方

```html
<div class="section-card">
  <div class="flex items-center gap-3 mb-6">
    <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
      <i data-lucide="cpu" class="w-6 h-6 text-blue-600"></i>
    </div>
    <div>
      <h2 class="text-2xl font-bold text-gray-800">セクションタイトル</h2>
      <p class="text-gray-500">サブタイトル（どんな内容か一言で）</p>
    </div>
  </div>
  <!-- コンテンツ -->
</div>
```

---

## コード例の前の日本語解説

コードを見せる前に、必ず「このコードが何をするか」を日本語で説明する。

```html
<div class="mt-6">
  <div class="flex items-center gap-2 mb-2">
    <i data-lucide="code" class="w-5 h-5 text-purple-500"></i>
    <span class="font-bold text-gray-700">このコードがやること</span>
  </div>
  <p class="text-gray-600 mb-3 ml-7">
    【コードの動作を日本語で説明。何が入力で、何が出力か。】
  </p>
  <div class="code-block">
    <pre><code>// コードをここに記述</code></pre>
  </div>
</div>
```

---

## フローチャートの表現

```html
<div class="flex flex-col md:flex-row items-center justify-center gap-4 my-8">
  <div class="bg-sky-100 px-6 py-4 rounded-xl text-center">
    <i data-lucide="play" class="w-8 h-8 text-sky-600 mx-auto mb-2"></i>
    <div class="font-bold text-sm">開始</div>
  </div>
  <i data-lucide="arrow-right" class="w-8 h-8 text-gray-400 hidden md:block"></i>
  <i data-lucide="arrow-down" class="w-8 h-8 text-gray-400 md:hidden"></i>
  <div class="bg-amber-100 px-6 py-4 rounded-xl text-center">
    <i data-lucide="settings" class="w-8 h-8 text-amber-600 mx-auto mb-2"></i>
    <div class="font-bold text-sm">処理</div>
  </div>
  <i data-lucide="arrow-right" class="w-8 h-8 text-gray-400 hidden md:block"></i>
  <i data-lucide="arrow-down" class="w-8 h-8 text-gray-400 md:hidden"></i>
  <div class="bg-emerald-100 px-6 py-4 rounded-xl text-center">
    <i data-lucide="check-circle" class="w-8 h-8 text-emerald-600 mx-auto mb-2"></i>
    <div class="font-bold text-sm">完了</div>
  </div>
</div>
```

---

## よく使うLucide Iconアイコン一覧

| 用途 | アイコン名 |
|-----|----------|
| マップ・概要 | `map`, `compass` |
| 重要 | `alert-circle` |
| ヒント | `lightbulb` |
| チェック | `check-circle` |
| 情報 | `info` |
| 警告 | `triangle-alert` |
| 制御・CPU | `cpu` |
| コード | `code` |
| 設定・歯車 | `settings` |
| 矢印 | `arrow-right`, `arrow-down` |
| ファイル | `file-text` |
| 本 | `book-open` |
| リンク | `external-link` |
| 学習 | `graduation-cap` |
| 次へ | `arrow-right-circle` |
| 再生 | `play` |
| 完了 | `check` |
