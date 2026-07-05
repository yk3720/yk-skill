# BriefMap — HTML パーツ断片

Tailwind（ads 配色）· Lucide のみ。絵文字禁止。  
proposalmap の [proposal-parts.md](../../creating-proposalmap-yk/references/proposal-parts.md) と同型。文言だけ briefmap 用。

## 資料種別帯（notice · hybrid）

```html
<div class="rounded-xl border border-ads-accent/30 bg-ads-accent/5 px-4 py-3 mb-8 flex gap-3">
  <i data-lucide="file-text" class="w-5 h-5 text-ads-accent shrink-0 mt-0.5"></i>
  <p class="text-sm text-ads-text leading-relaxed">
    本資料は<strong>調査結果の報告</strong>と<strong>運用方針のご判断依頼</strong>用です。正本: <code class="text-xs">…</code>
  </p>
</div>
```

## お願い（ask）

```html
<section id="ask" class="mb-12">
  <h2 class="text-lg font-bold text-ads-text mb-2 flex items-center gap-2">
    <i data-lucide="help-circle" class="w-5 h-5 text-ads-accent"></i>
    ご判断いただきたい点
    <span class="text-xs font-medium text-ads-warning ml-1">提案</span>
  </h2>
  <ol class="list-decimal pl-5 space-y-2 text-sm text-ads-text">
    <li>…</li>
  </ol>
</section>
```

## 5分要約（summary）

```html
<section id="summary" class="mb-12">
  <h2 class="text-lg font-bold text-ads-text mb-4 flex items-center gap-2">
    <i data-lucide="clipboard-list" class="w-5 h-5 text-ads-accent"></i>
    5分で把握
    <span class="text-xs font-medium text-ads-dim ml-1">解釈</span>
  </h2>
  <ul class="space-y-2 text-sm bg-ads-surface rounded-xl p-5 border border-ads-border">
    <li><span class="font-medium text-ads-text">結論：</span>…</li>
    <li><span class="font-medium text-ads-text">現状：</span>…</li>
    <li><span class="font-medium text-ads-text">推奨：</span>…</li>
  </ul>
</section>
```

## 選択肢表（options）

```html
<div class="overflow-x-auto rounded-xl border border-ads-border">
  <table class="w-full text-sm">
    <thead class="bg-ads-surface">
      <tr>
        <th class="text-left p-3 font-semibold text-ads-text">構成</th>
        <th class="text-left p-3 font-semibold text-ads-text">内容</th>
        <th class="text-left p-3 font-semibold text-ads-text">月額</th>
      </tr>
    </thead>
    <tbody class="divide-y divide-ads-border">
      <tr class="bg-emerald-50/50">
        <td class="p-3 font-medium">B <span class="text-xs text-ads-positive">推奨</span></td>
        <td class="p-3">…</td>
        <td class="p-3 font-mono">…</td>
      </tr>
    </tbody>
  </table>
</div>
<p class="text-xs text-ads-dim mt-2">出典: 正本 §…</p>
```

## サービス構成（arch · 簡易）

```html
<div class="grid grid-cols-2 md:grid-cols-4 gap-2 text-sm my-4">
  <div class="rounded-lg border-2 border-ads-border bg-ads-surface p-3 text-center">GitHub<br><span class="text-xs text-ads-dim">ソース</span></div>
  <!-- … -->
</div>
```

## リスク（risks）

```html
<div class="rounded-lg border border-ads-warning/40 bg-amber-50/80 p-4 text-sm">
  <p class="font-medium text-ads-text mb-2 flex items-center gap-2">
    <i data-lucide="alert-triangle" class="w-4 h-4 text-ads-warning"></i>
    リスクと対策
    <span class="text-xs font-normal text-ads-dim">事実</span>
  </p>
  <ul class="list-disc pl-5 space-y-1 text-ads-muted">…</ul>
</div>
```

## 種別ラベル（共通）

```html
<span class="text-xs font-medium text-ads-dim">事実</span>
<span class="text-xs font-medium text-ads-accent">解釈</span>
<span class="text-xs font-medium text-ads-warning">提案</span>
```
