# Cursor（Windows）作業ルール

## このルールが必要な背景

`cursor --help` に載っていないオプションがある、サンドボックスではユーザーホームへの書き込みや `git clone` が失敗する、内蔵ブラウザの開き方がドキュメントと一致しない、といった事象が起きる。エージェントが迷わないための実務メモ。

対象：Windows（PowerShell）、Cursor デスクトップ。

---

## ルール1：Git クローン先は事前にユーザーへ確認する

### なぜ重要か

保存場所の希望がなければ、後からパス探し・移動で手戻りになる。

### 正しいやり方

1. **クローン実行前に**、希望の保存場所を聞く。
2. ユーザーが場所を決められない場合は **「おまかせ」** と返してもらうよう案内する。
3. **「おまかせ」のとき**  
   - ホーム直下に `src` フォルダがなければ作成する。  
   - **`%USERPROFILE%\src`**（例：`C:\Users\<ユーザー>\src`）の中にクローンする。  
   - すでに `src` がある場合は、その中にクローンする。

---

## ルール2：フォルダを新しい Cursor ウィンドウで開く

### コマンド例（PowerShell）

```powershell
cursor --new-window "C:\path\to\folder"
```

PATH に `cursor` が通っていない場合は、`Cursor.exe` のフルパスを使う（ルール3参照）。

---

## ルール3：内蔵ブラウザで `http://localhost:<PORT>` を開く（Windows）

### なぜ重要か

- **`cursor --help` に `--open-url` は出てこない**が、Windows では URL プロトコル登録により **`Cursor.exe --open-url -- "<URL>"`** が使われる。
- **localhost の http/https** は VS Code 由来の Simple Browser 拡張の外部 URI オープナー／統合ブラウザ側の挙動につながり、**外部の既定ブラウザではなくエディタ内**で開ける。

### 前提

ローカルアプリを見る場合は、**先に開発サーバーがそのポートで待ち受けていること**（例：Next.js なら `npm run dev`、既定は多くの場合ポート 3000）。

### 推奨コマンド（インストール先が既定のとき）

```powershell
& "$env:LOCALAPPDATA\Programs\cursor\Cursor.exe" --open-url -- "http://localhost:3000"
```

ポートはプロジェクトに合わせて変える（例：`3000`、`5173`）。

### PATH に `cursor` がある場合

```powershell
cursor --open-url -- "http://localhost:3000"
```

**`--` は URL が `-` で始まる引数と解釈されるのを防ぐため付ける（習慣として推奨）。**

### フォールバック（CLI が効かない・別ウィンドウに取られた場合）

1. **`Ctrl+Shift+P`** → **`Simple Browser: Show`**（表示名はバージョンで多少異なる場合あり）  
2. 入力ボックスに `http://localhost:<PORT>` を入力する。

---

## ルール4：エージェント実行環境での権限

### なぜ重要か

サンドボックスでは **ワークスペース外（ユーザーの `src` など）への書き込み**や **`git clone`・ネットワーク**が拒否されることがある。

### 正しいやり方

- **`.git` 書き込み・push・Playwright** などは、初回 Shell から **`required_permissions: ["all"]`** を使う（サンドボックス失敗→再 RUN を避ける）。詳細は **ルール5**。
- ホーム直下への clone 等でサンドボックスが足りないときも **`all`**。
- 権限の種類が不明な一般コマンドのみ、失敗後に権限を広げて再試行する。

---

## ルール5：Shell / RUN 承認の削減（横断 SSOT）

**本文は転記しない。** → [`60_tooling/AGENT_SHELL_RULES.md`](AGENT_SHELL_RULES.md)

| 誰 | やること |
|----|----------|
| **人間** | Auto-Run = **Allowlist** · `~/.cursor/permissions.json` · §2 チェックリスト |
| **エージェント** | 確認は Read/Glob · Shell は commit/終了等のみ · 同一ターンは `;` で 1 本 |

---

## 参考：URL プロトコル登録の確認（任意）

Cursor が `--open-url` を使うかはレジストリで確認できる。

```powershell
reg query "HKCU\Software\Classes\cursor\shell\open\command"
```

インストール先が異なる場合は、`Cursor.exe` の実パスに合わせてルール3のコマンドを書き換える。
