# ProposalMap — HTML パーツ断片

Tailwind（ads 配色）・Lucide のみ。絵文字禁止。

## 周知帯（notice）

```html
<div class="rounded-xl border border-ads-accent/30 bg-ads-accent/5 px-4 py-3 mb-8 flex gap-3">
  <i data-lucide="info" class="w-5 h-5 text-ads-accent shrink-0 mt-0.5"></i>
  <p class="text-sm text-ads-text leading-relaxed">
    本資料は、現在検討・開発中の取り組みを関係者に共有するための<strong>周知用</strong>説明です。決裁・予算のご依頼を含みません。
  </p>
</div>
```

（誤字修正: 取り組み）

## 3分要約カード

```html
<section id="summary" class="mb-12">
  <h2 class="text-lg font-bold text-ads-text mb-4 flex items-center gap-2">
    <i data-lucide="clipboard-list" class="w-5 h-5 text-ads-accent"></i>
    3分で把握
  </h2>
  <ul class="space-y-2 text-sm bg-ads-surface rounded-xl p-5 border border-ads-border">
    <li><span class="font-medium text-ads-text">何を：</span>…</li>
    <li><span class="font-medium text-ads-text">なぜ：</span>…</li>
    <li><span class="font-medium text-ads-text">どうする：</span>…</li>
    <li><span class="font-medium text-ads-text">範囲：</span>…</li>
    <li><span class="font-medium text-ads-text">お願い：</span>…</li>
  </ul>
</section>
```

## やる／やらない 表

```html
<div class="overflow-x-auto rounded-xl border border-ads-border">
  <table class="w-full text-sm">
    <thead class="bg-ads-surface">
      <tr>
        <th class="text-left p-3 font-semibold text-ads-text">できること</th>
        <th class="text-left p-3 font-semibold text-ads-text">今回しないこと</th>
      </tr>
    </thead>
    <tbody class="divide-y divide-ads-border">
      <tr>
        <td class="p-3 align-top">…</td>
        <td class="p-3 align-top text-ads-muted">… <span class="text-xs">（理由：…）</span></td>
      </tr>
    </tbody>
  </table>
</div>
```

## 簡易フロー（業務語）

```html
<div class="flex flex-col md:flex-row items-stretch gap-2 md:gap-0 text-sm my-6">
  <div class="flex-1 rounded-lg border border-ads-border bg-ads-surface p-4 text-center">表で手順を書く</div>
  <div class="hidden md:flex items-center px-2 text-ads-dim"><i data-lucide="arrow-right" class="w-4 h-4"></i></div>
  <div class="flex-1 rounded-lg border border-ads-border bg-ads-surface p-4 text-center">図の形を自動で整える</div>
  <div class="hidden md:flex items-center px-2 text-ads-dim"><i data-lucide="arrow-right" class="w-4 h-4"></i></div>
  <div class="flex-1 rounded-lg border border-ads-accent/40 bg-ads-accent/5 p-4 text-center font-medium">ブラウザで確認・保存・PNG</div>
</div>
```

## 用語ボックス

```html
<dl class="grid gap-3 text-sm">
  <div class="rounded-lg border border-ads-border p-3">
    <dt class="font-semibold text-ads-text">用語名</dt>
    <dd class="mt-1 text-ads-muted">定義（です・ます）</dd>
  </div>
</dl>
```
