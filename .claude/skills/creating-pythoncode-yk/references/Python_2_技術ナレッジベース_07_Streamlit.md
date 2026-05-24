# Python 技術ナレッジベース Streamlit (Field Manual - Streamlit)
## ■ 本書の役割
Streamlitアプリケーション開発に関するナレッジ。

---

## 第1章：Streamlit アプリケーション開発

### [K-036] Streamlit アプリケーションの実行方法
- **uvによる実行**: `uv run streamlit run main.py` を標準とせよ。
- **[K-036-1] 一撃必中エントリポイント**: `main.py` に `is_running_streamlit()` 判定と `subprocess.run(["uv", "run", "streamlit", "run", __file__])` による自己再起動ロジックを組み込め。

### [K-037] st.session_state の None チェック
- **防御的プログラミング**: キーの存在確認だけでなく、値が `None` でないことを常に保証せよ。

### [K-038] Plotly チャート実装と画像保存
- **kaleido 依存**: 画像出力（png/pdf 等）を行う場合は、`kaleido` ライブラリの導入が必須。

### [K-039] 起動確認とトラブルシューティング
- **ポート管理**: 複数アプリを起動する際は `--server.port` で明示的にポートを指定せよ。

### [K-042] Streamlit: 動的パラメータ同期と即時反映パターン
- **解決策**: UIコンポーネントの `key` を `st.session_state` にバインドし、`on_change` コールバックでロジックを実行する。

### [K-043] ブラウザ翻訳プロンプトの抑制 (lang属性の強制指定)
- **課題**: 日本語UIのStreamlitアプリが英語サイトと誤認され、ブラウザが翻訳を勧めてしまう。
- **解決策**: `st.markdown` を使用し、JavaScriptで `document.documentElement.lang = 'ja';` を実行する。

### [K-044] Plotly ズーム状態の維持とリセット管理 (uirevision)
- **課題**: チャートを手動ズームした後、外部ボタン（自動計算など）で範囲を更新しても、Plotlyがズーム状態を維持してしまい反映されない。
- **解決策**: `fig.update_layout` の `uirevision` パラメータに、**手動でインクリメントするリビジョン番号**を使用せよ。
- **運用（一発必中）**: 
    1. `st.session_state.chart_revision` 等のカウンタを用意する。
    2. 「範囲を強制リセットしたい操作（ボタン押下、ファイル読込）」の際にのみ、このカウンタを `+1` する。
    3. `fig.update_layout(uirevision=st.session_state.chart_revision)` と設定する。
- **メリット**: 数値（範囲）が変わらない場合でも、ボタンを押すたびに確実にズームを解除して全体表示に戻すことができる。
