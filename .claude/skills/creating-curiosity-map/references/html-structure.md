# HTML構造ガイド（CuriosityMap版）

## 基本テンプレート

```html
<!DOCTYPE html>
<html lang="ja">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>【図解タイトル】- CuriosityMap</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://unpkg.com/lucide@latest"></script>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;500;700&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    :root {
      --cmap-primary: #3d2c8d;
      --cmap-accent: #9b59b6;
      --cmap-warm: #e67e22;
      --cmap-gradient: linear-gradient(135deg, #3d2c8d 0%, #9b59b6 100%);
    }

    body {
      font-family: 'Noto Sans JP', 'Inter', sans-serif;
    }

    .header-gradient {
      background: var(--cmap-gradient);
    }

    .section-card {
      background: white;
      border-radius: 1rem;
      box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
      padding: 2rem;
      margin-bottom: 2rem;
    }

    /* 用語解説ボックス */
    .term-explain {
      background: linear-gradient(135deg, #f3e8ff 0%, #e9d5ff 100%);
      border-left: 4px solid #9b59b6;
      padding: 1.5rem;
      border-radius: 0.75rem;
      margin: 1.5rem 0;
    }
    .term-word {
      color: #6b21a8;
    }

    /* たとえ話ボックス */
    .analogy-box {
      background: linear-gradient(135deg, #fef9c3 0%, #fde68a 100%);
      border-left: 4px solid #f59e0b;
      padding: 1.5rem;
      border-radius: 0.75rem;
      margin: 1.5rem 0;
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
      color: #7c3aed;
      transition: background 0.15s;
    }
    .ref-link:hover {
      background: #f3e8ff;
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
      background: var(--cmap-gradient);
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
      box-shadow: 0 4px 14px rgba(155, 89, 182, 0.4);
      transition: opacity 0.15s, transform 0.15s;
      z-index: 100;
    }
    .pdf-btn:hover {
      opacity: 0.9;
      transform: translateY(-2px);
    }

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
      <li><a href="#summary" class="text-gray-600 hover:text-purple-600">概要</a></li>
      <li><a href="#why" class="text-gray-600 hover:text-purple-600">なぜ注目？</a></li>
      <li><a href="#basics" class="text-gray-600 hover:text-purple-600">まず3つ</a></li>
      <li><a href="#details" class="text-gray-600 hover:text-purple-600">しくみ</a></li>
      <li><a href="#misconceptions" class="text-gray-600 hover:text-purple-600">よくある誤解</a></li>
      <li><a href="#glossary" class="text-gray-600 hover:text-purple-600">用語集</a></li>
      <li><a href="#related" class="text-gray-600 hover:text-purple-600">もっと知りたい</a></li>
      <li><a href="#references" class="text-gray-600 hover:text-purple-600">参考文献</a></li>
    </ul>
  </nav>

  <!-- ヘッダー -->
  <header class="header-gradient text-white py-10">
    <div class="max-w-4xl mx-auto px-4">
      <div class="flex items-center gap-2 mb-3">
        <span class="text-xs bg-white/20 px-3 py-1 rounded-full font-medium tracking-wide">CuriosityMap</span>
        <span class="text-xs bg-white/20 px-3 py-1 rounded-full font-medium">【カテゴリ】</span>
      </div>
      <h1 class="text-3xl md:text-4xl font-bold">【タイトル】</h1>
      <p class="mt-2 text-lg opacity-90">【サブタイトル：一文で何の話か説明】</p>
    </div>
  </header>

  <!-- メインコンテンツ -->
  <main class="max-w-4xl mx-auto px-4 py-8">

    <!-- ひとことで言えば -->
    <section id="summary" class="section-card">
      <!-- 一文サマリー・対象・カバー範囲 -->
    </section>

    <!-- なぜ注目されているのか -->
    <section id="why" class="section-card">
      <!-- 背景・歴史・日常との関係 -->
    </section>

    <!-- まず理解する3つ -->
    <section id="basics" class="section-card">
      <!-- 絞り込み3ポイント -->
    </section>

    <!-- 主要概念・しくみ -->
    <section id="details">
      <!-- 各概念のセクションカード（たとえ話3つ以上を含む） -->
    </section>

    <!-- よくある誤解 -->
    <section id="misconceptions" class="section-card">
      <!-- 思い込みと正しい理解 -->
    </section>

    <!-- 知っておきたい言葉 -->
    <section id="glossary" class="section-card">
      <!-- 5〜15語の用語集 -->
    </section>

    <!-- もっと知りたい人へ -->
    <section id="related" class="section-card">
      <!-- 関連トピック -->
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

## 用語解説ボックス

```html
<div class="term-explain">
  <div class="flex items-start gap-4">
    <i data-lucide="lightbulb" class="w-8 h-8 text-purple-500 flex-shrink-0"></i>
    <div>
      <div class="term-word text-xl font-bold">「〇〇」とは？</div>
      <div class="text-lg mt-2">
        難しそうな響きですが、要するに<span class="font-bold text-purple-700">「△△すること」</span>を指しています。<br>
        日常でたとえると、<strong>□□と同じ仕組み</strong>です。
      </div>
    </div>
  </div>
</div>
```

---

## たとえ話ボックス

```html
<div class="analogy-box">
  <div class="flex items-start gap-3">
    <i data-lucide="message-circle" class="w-6 h-6 text-amber-600 flex-shrink-0 mt-0.5"></i>
    <div>
      <div class="font-bold text-amber-800 mb-1">わかりやすく言うと…</div>
      <p class="text-gray-800">
        【日常のたとえ話を具体的に書く。「〇〇に似ています」ではなく、仕組みの対応を明示する。】
      </p>
    </div>
  </div>
</div>
```

---

## 一言サマリーボックス

```html
<div class="section-card" id="summary">
  <div class="flex items-center gap-3 mb-4">
    <div class="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center">
      <i data-lucide="map" class="w-6 h-6 text-purple-600"></i>
    </div>
    <div>
      <h2 class="text-2xl font-bold text-gray-800">ひとことで言えば</h2>
      <p class="text-gray-500">まずここだけ押さえてください</p>
    </div>
  </div>
  <div class="bg-gradient-to-r from-purple-50 to-violet-50 border border-purple-200 rounded-xl p-6">
    <p class="text-xl font-bold text-purple-900">【トピック名】とは、〇〇するための△△です。</p>
    <p class="mt-3 text-gray-700">【存在意義・なぜ生まれたかを2〜3文で説明。日常との接点を必ず入れる。】</p>
  </div>
</div>
```

---

## よくある誤解セクション

```html
<div class="section-card" id="misconceptions">
  <div class="flex items-center gap-3 mb-6">
    <div class="w-12 h-12 bg-red-100 rounded-xl flex items-center justify-center">
      <i data-lucide="alert-triangle" class="w-6 h-6 text-red-500"></i>
    </div>
    <div>
      <h2 class="text-2xl font-bold text-gray-800">よくある誤解・思い込み</h2>
      <p class="text-gray-500">「実は違った」という気づきのポイント</p>
    </div>
  </div>
  <div class="space-y-4">
    <div class="flex gap-4 p-4 bg-red-50 rounded-xl border border-red-200">
      <i data-lucide="x-circle" class="w-6 h-6 text-red-500 flex-shrink-0 mt-0.5"></i>
      <div>
        <div class="font-bold text-red-700">よくある誤解</div>
        <p class="text-gray-700 mt-1">【誤解の内容を具体的に書く】</p>
      </div>
    </div>
    <div class="flex gap-4 p-4 bg-green-50 rounded-xl border border-green-200">
      <i data-lucide="check-circle" class="w-6 h-6 text-green-500 flex-shrink-0 mt-0.5"></i>
      <div>
        <div class="font-bold text-green-700">実際はこうです</div>
        <p class="text-gray-700 mt-1">【正しい理解を分かりやすく書く】</p>
      </div>
    </div>
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
      <h2 class="text-2xl font-bold text-gray-800">もっと知りたい人へ</h2>
      <p class="text-gray-500">次に調べると面白いトピック</p>
    </div>
  </div>
  <div class="grid sm:grid-cols-2 gap-4">
    <div class="flex items-start gap-3 p-4 bg-emerald-50 rounded-xl border border-emerald-200">
      <i data-lucide="arrow-right-circle" class="w-6 h-6 text-emerald-600 flex-shrink-0 mt-0.5"></i>
      <div>
        <div class="font-bold text-gray-800">【関連トピック名】</div>
        <div class="text-sm text-gray-600 mt-1">【なぜ関連するか・どんな面白さがあるかを一言で】</div>
      </div>
    </div>
  </div>
</div>
```

---

## よく使うLucide Iconアイコン一覧

| 用途 | アイコン名 |
|-----|----------|
| マップ・概要 | `map`, `compass` |
| 気づき・ヒント | `lightbulb` |
| たとえ話 | `message-circle` |
| 正しい | `check-circle` |
| 誤解・注意 | `alert-triangle`, `x-circle` |
| 情報 | `info` |
| 本・学習 | `book-open`, `graduation-cap` |
| リンク | `external-link` |
| 次へ | `arrow-right-circle` |
| 用語 | `tag` |
| 疑問 | `help-circle` |
| 保存 | `download` |
