---
name: tex-writer
description: 日本語 TeX 文書と関連するビルドファイルを標準の LuaLaTeX 構成で作成・更新する。TeX の雛形作成、必要パッケージや listings 設定の追加、TeX 用 Makefile の生成や更新を求められたときに使う。
---

# TeX Writer

このスキルは、TeX ファイル本体とそのビルドファイルを作成・更新するためのものである。

次のような依頼で使う。

- 新しい `.tex` ファイルを作る
- 既存の `.tex` ファイルを書き換える、拡張する
- 日本語 LuaLaTeX 文書向けの標準パッケージ構成を入れる
- TeX 文書のビルドに使う `Makefile` を生成または更新する

このスキルはレポート固有の構成や体裁には使わない。固定の章立て、著者欄、環境表、レポート執筆ルールのような内容は無視する。

## 必須ワークフロー

このスキルが TeX 文書作成で呼ばれた場合は、必ず次を行う。

1. 対象の `.tex` ファイルを作成または更新する。
2. 同じ出力対象に `Makefile` を作成または更新する。
3. ビルド手順の案内は必ず `Makefile` を使う。

互換性のある `Makefile` が既にある場合はそれを維持する。ない場合は `assets/Makefile` を配置する。

新規に TeX 文書を作る場合は `assets/report.tex` を出発点にし、内容そのものは別の要求に応じて組み立てる。

## TeX の基本設定

ユーザーから明示的な指定がない限り、次を基本設定として使う。

- エンジン: LuaLaTeX
- ドキュメントクラス: `\documentclass[11pt,a4paper]{ltjsarticle}`
- 日本語対応: `luatexja`, `luatexja-fontspec`
- フォント設定は、ユーザーから要求がない限り明示しない

## 標準パッケージ

基本構成の文書を作るときは、次のパッケージを入れる。

- `amsmath, amsfonts, amssymb`
- `bm`
- `physics`
- `mathtools`
- `graphicx`
- `float`
- `subcaption`
- `makecell`
- `hhline`
- `url`
- `multirow`
- `ascmac`
- `cases`
- `upgreek`
- `xcolor`
- `listings, jvlisting`

`listings` の設定は、ユーザーから変更要求がない限りアセットの内容をそのまま使う。
他に必要なパッケージがあれば適宜使用する。

## ビルドルール

ビルド手順は必ず生成した `Makefile` を通して扱い、単発の `latexmk` コマンドを直接案内しない。

基本コマンドは次のとおり。

- ビルド: `make`
- 監視ビルド: `make watch`
- 中間ファイル削除: `make clean`
- 完全削除: `make distclean`

## アセット

- `assets/report.tex`: 標準のプリアンブルと `listings` 設定だけを持つ最小 TeX テンプレート
- `assets/Makefile`: LuaLaTeX 用の標準ビルドファイル
