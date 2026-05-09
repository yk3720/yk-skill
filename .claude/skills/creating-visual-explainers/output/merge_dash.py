import sys
sys.path.insert(0, 'C:/yk-skill/.claude/skills/creating-visual-explainers/output/pylib')
from PIL import Image
import base64

img1_path = r"C:\Users\ykoba\.cursor\projects\c-yk-memo\assets\c__Users_ykoba_AppData_Roaming_Cursor_User_workspaceStorage_aa2b727f24e096b824425b87f0290243_images______2______________-3b14185b-f246-445e-b431-76eb04eeefa8.png"
img2_path = r"C:\Users\ykoba\.cursor\projects\c-yk-memo\assets\c__Users_ykoba_AppData_Roaming_Cursor_User_workspaceStorage_aa2b727f24e096b824425b87f0290243_images______3____________-4ffe0234-4c91-4328-a7cc-bf6804f346f0.png"

img1 = Image.open(img1_path)
img2 = Image.open(img2_path)

print(f"img1: {img1.width}x{img1.height}")
print(f"img2: {img2.width}x{img2.height}")

# img1: 下部のナビゲーションバー(約330px)をカット
# img2: 上部の重複ヘッダー+重複カード部分(約600px)をカット
crop1_bottom = int(img1.height * 0.80)   # 上80%を使用（ナビバー+セクションヘッダー除去）
crop2_top    = int(img2.height * 0.27)   # 上27%をスキップ（重複部分除去）

img1_crop = img1.crop((0, 0, img1.width, crop1_bottom))
img2_crop = img2.crop((0, crop2_top, img2.width, img2.height))

# 幅を揃えて縦結合
w = max(img1_crop.width, img2_crop.width)
def resize_to_width(img, target_w):
    ratio = target_w / img.width
    return img.resize((target_w, int(img.height * ratio)), Image.LANCZOS)

img1_crop = resize_to_width(img1_crop, w)
img2_crop = resize_to_width(img2_crop, w)

merged = Image.new('RGB', (w, img1_crop.height + img2_crop.height), (255,255,255))
merged.paste(img1_crop, (0, 0))
merged.paste(img2_crop, (0, img1_crop.height))

out_path = r"C:\yk-skill\.claude\skills\creating-visual-explainers\output\dashboard_merged.png"
merged.save(out_path, 'PNG', optimize=True)
print(f"Merged: {w}x{img1_crop.height + img2_crop.height}")

with open(out_path, 'rb') as f:
    b64 = base64.b64encode(f.read()).decode('ascii')
with open(r"C:\yk-skill\.claude\skills\creating-visual-explainers\output\b64_dash_merged.txt", 'w', encoding='ascii') as f:
    f.write(b64)
print(f"B64 length: {len(b64)}")
