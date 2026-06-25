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

---

## ルール6：Team プランの有料範囲（含まれる使用量）の残り確認

**最終確認:** 2026-06-25（公式ドキュメント・フォーラム・ブログを Web 調査）

### 結論（どこで見るか）

| 確認したい内容 | 場所 | 備考 |
|----------------|------|------|
| **自分の含まれる使用量の残り** | [cursor.com/dashboard](https://cursor.com/dashboard) → **Usage** | Member も Admin も自分分はここ |
| **IDE 内のサマリー** | Cursor → **Settings → General → Usage Summary** を **Always** | アカウントにより項目が出ない場合あり |
| **チーム全体・メンバー別** | 同上ダッシュボード（**Admin** でサインイン） | Usage で個人・合計・推移 |
| **含まれる分を超えた従量（On-demand）** | ダッシュボード **Spending** / **Billing** | On-demand 無効時は Spending はほぼ空で正常 |
| **次回リセット日** | ダッシュボード → **Manage Subscription** | Team は全員が同一の請求サイクルでリセット |

**Spending タブは「含まれる使用量の残り」ではない。** 含まれる分を使い切ったあとの超過課金（On-demand）用。残りは **Usage** タブを見る。

### Team プランの使用量の考え方

- 各 **有料シート**（Standard / Premium）に、**ユーザー単位**で月次の含まれる使用量が付く。メンバー間で譲渡・共有しない。
- 2026-06 時点の Teams 料金改定後、含まれる使用量は **2 プール**に分かれる（[Improvements to Teams Pricing · Cursor](https://cursor.com/blog/teams-pricing-june-2026)）:
  1. **Composer and Auto** — Cursor 自社モデル・Auto 用
  2. **Third-party API models** — Claude / GPT 等の第三者モデル用
- **Standard:** $40/ユーザー/月（月払い）— 標準の含まれる使用量
- **Premium:** $120/ユーザー/月 — Standard の **5 倍**の含まれる使用量
- 含まれる分を使い切ると、On-demand が有効なら従量課金で継続（Teams では **既定で On-demand 有効**）。無効ならエディタ通知後に Auto / Composer への切り替え等（[Team Pricing](https://cursor.com/docs/account/teams/pricing)）。
- 未使用分は **翌月へ繰越されない**。Team 全員が **チームの請求サイクル**で同時にリセット（[Usage and limits](https://cursor.com/help/models-and-usage/usage-limits)）。

### ロール別に見える範囲

| ロール | 自分の残り | 他メンバー・チーム全体 |
|--------|------------|------------------------|
| **Member** | ✓（Usage） | ✗ |
| **Admin** | ✓ | ✓（Usage・分析） |
| **Unpaid Admin** | ✗（Cursor 未使用） | ✓（管理画面） |

出典: [Members, Roles, and Seat Types](https://cursor.com/docs/account/teams/members) · [Manage your team](https://cursor.com/help/account-and-billing/teams-management)

### Usage タブの表示について（2026-06 時点の注意）

- 公式: Usage に **リアルタイムの使用量・残り・On-demand 料金**を表示（[Usage and limits](https://cursor.com/help/models-and-usage/usage-limits)）。
- **進捗バー / サマリーチャート**は段階的ロールアウト中。アカウントによって Usage に表だけしか出ないことがある（[フォーラム: Usage not showing](https://forum.cursor.com/t/usage-not-showing/154766)）。
- チャート未表示時は **Usage のリクエスト一覧**で消費を追う。Enterprise 等で IDE の **Usage Summary 設定自体が消える**既知事象あり → その場合は Web ダッシュボードが正。

### Admin API（プログラムで集計する場合）

Admin が API キーを発行し、以下で請求サイクル内の利用・支出を取得できる（[Admin API](https://cursor.com/docs/account/teams/admin-api)）:

- `GET /teams/spend` — メンバー別 On-demand 支出・全体支出
- `POST /teams/daily-usage-data` — 日次利用（ポーリングは **1 時間に 1 回以下**推奨）
- `POST /teams/filtered-usage-events` — イベント単位（`chargedCents` の合計でダッシュボードと突合）

### 参照 URL（公式）

| 内容 | URL |
|------|-----|
| 使用量・上限の一般説明 | https://cursor.com/help/models-and-usage/usage-limits |
| Team 料金・含まれる使用量・On-demand | https://cursor.com/docs/account/teams/pricing |
| Team ダッシュボード | https://cursor.com/docs/account/teams/dashboard |
| メンバー・ロール・シート | https://cursor.com/docs/account/teams/members |
| チーム管理（利用状況の見方） | https://cursor.com/help/account-and-billing/teams-management |
| Admin API | https://cursor.com/docs/account/teams/admin-api |
| Teams 料金改定（2026-06） | https://cursor.com/blog/teams-pricing-june-2026 |
