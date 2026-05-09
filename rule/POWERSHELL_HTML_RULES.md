# PowerShell × 大容量HTML 作業ルール

## このルールが必要な背景

Base64画像を埋め込んだHTMLは900KB〜2MB超になる。
PowerShellでこのサイズのファイルを操作する際に特有の落とし穴がある。
過去の失敗から得た必須ルールをまとめる。

---

## ルール1：ファイル保存は必ずBOMなしUTF-8で行う

### なぜ重要か
PowerShellの `[System.IO.File]::WriteAllText(path, content)` は
**デフォルトでBOM付きUTF-8**で保存する。
ブラウザはBOMを検出すると `<meta charset="UTF-8">` を無視するため、
日本語が文字化けする。

### 正しい書き方
```powershell
# NG（BOM付きになる）
[System.IO.File]::WriteAllText($path, $content)

# OK（BOMなしUTF-8）
$utf8 = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText($path, $content, $utf8)
```

---

## ルール2：PowerShellスクリプト内に日本語マーカー文字列を書かない

### なぜ重要か
PowerShellスクリプト内に日本語文字列を含めると、
スクリプト自体のエンコーディング（CP932）の問題で
`IndexOf` や `Contains` が `-1` / `False` を返すことがある。

### 正しいやり方
HTMLの挿入点マーカーは必ず**ASCII文字だけのCSSクラス名やHTMLタグ**を使う。

```powershell
# NG
$marker = "ダッシュボードセクション"

# OK
$marker = 'class="layout-dashboard"'
$marker = '<div class="grid grid-cols-1 md:grid-cols-2 gap-4">'
```

HTMLを設計する時点で、挿入・置換しやすい**英語のプレースホルダー**を仕込んでおくのがベスト。

```html
<!-- 挿入点にプレースホルダーコメントを置く -->
SECTION_DASHBOARD_PLACEHOLDER
SECTION_FORM_PLACEHOLDER
```

---

## ルール3：大きなHTMLの操作はコマンドを分割する

### なぜ重要か
900KB超のファイルでReadAllBytes→文字列変換→複数Replace→WriteAllTextを
**1コマンドに詰め込むと**、サンドボックスや処理制限でNullエラーになる。

### 正しいやり方：処理をステップファイルに分割する

```powershell
# Step1: ファイル読み込みと1つ目のReplace
$b = [System.IO.File]::ReadAllBytes($path)
$s = [System.Text.Encoding]::UTF8.GetString($b)
$s = $s.Replace("PLACEHOLDER_A", $contentA)
$utf8 = [System.Text.UTF8Encoding]::new($false)
[System.IO.File]::WriteAllText("step1.html", $s, $utf8)

# Step2: step1.htmlを読み込んで2つ目のReplace
$b = [System.IO.File]::ReadAllBytes("step1.html")
$s = [System.Text.Encoding]::UTF8.GetString($b)
$s = $s.Replace("PLACEHOLDER_B", $contentB)
[System.IO.File]::WriteAllText("step2.html", $s, $utf8)
```

1コマンドに詰め込める最大のめやす：**ReadAllBytes 1回 + Replace 1〜2回 + WriteAllText 1回**

---

## ルール4：ReadAllBytesはサンドボックス外（all権限）が必要

```powershell
# サンドボックス内ではReadAllBytesがブロックされることがある
# → required_permissions: ["all"] で実行する
```

ファイルサイズが大きい（200KB超）場合は最初から `required_permissions: ["all"]` を指定する。

---

## ルール5：Base64埋め込みHTMLの組み立て手順（推奨フロー）

大量の画像をBase64でHTMLに埋め込む場合の標準手順：

```
1. Writeツールでベースとなるテンプレートを作成
   （プレースホルダーはすべて英語ASCII: SECTION_XXX_PLACEHOLDER）

2. 各セクションのHTMLもWriteツールで別ファイルとして作成
   （画像はPLACEHOLDER文字列で仮置き）

3. PowerShell: 画像ファイルをBase64化してtxtファイルに保存（1ファイルずつ）

4. Python（Pillow）: 画像の結合が必要な場合はここで処理

5. PowerShell: セクションHTMLのPLACEHOLDERをBase64に置換
   → 1ファイルずつ、1コマンド1ステップで

6. PowerShell: ベースHTMLのSECTION_XXX_PLACEHOLDERにセクションを挿入
   → 1セクションずつ、ステップファイル経由で

7. 完成したHTMLのFirst 3 bytesを確認（60 33 68 = <!D が正常）
```

---

## ルール6：Pythonが使える場合はPythonを優先する

PowerShellよりPythonの方が文字列処理・ファイル操作が安定している。

```python
# Python推奨パターン
with open(path, 'r', encoding='utf-8') as f:
    html = f.read()

html = html.replace("PLACEHOLDER", new_content)

with open(path, 'w', encoding='utf-8') as f:
    f.write(html)
```

Pillowが必要な場合のインストール：
```powershell
# ワークスペース内のフォルダに--targetでインストール（要 all権限）
pip install Pillow --target "C:\path\to\output\pylib"

# 使用時
import sys
sys.path.insert(0, 'C:/path/to/output/pylib')
from PIL import Image
```

---

## チェックリスト（デプロイ前）

- [ ] 保存したHTMLのFirst 3 bytesが `60 33 68`（= `<!D`）であること（BOMなし確認）
- [ ] ブラウザでローカルファイルを開いて日本語が正常表示されること
- [ ] target="_blank" の有無が意図通りであること
- [ ] 中間ステップファイル（step1.html, step2.html, b64_*.txt等）を削除したこと
