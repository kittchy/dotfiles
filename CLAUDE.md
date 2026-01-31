# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 概要

macOS 向けの dotfiles と開発環境管理リポジトリ。Nix + nix-darwin + Home Manager による宣言的な環境構築と、Chezmoi による dotfiles 管理を組み合わせています。

## よく使用されるコマンド

### Nix環境管理（go-task経由）

```bash
# nix-darwin設定の適用（初回・更新時）
task darwin-switch

# flake依存の更新
task update

# flake設定のチェック
task check

# ガベージコレクション実行
task clean
```

### Chezmoi（dotfiles管理）

```bash
# 初回適用
task chezmoi_initialize

# dotfilesの適用
chezmoi apply

# dotfilesの差分確認
chezmoi diff

# dotfilesの追加
chezmoi add <file>

# リポジトリからの取得と適用
chezmoi update
```

### 直接コマンド

```bash
# nix-darwin設定の適用（直接実行）
sudo nix run nix-darwin -- switch --flake ./nix#kiuchitakahirononotobukkukonpyuta

# flakeの更新
cd nix && nix flake update
```

## アーキテクチャ

### 環境管理の二層構造

1. **Nix層**: システムレベルのパッケージとサービスを管理
   - nix-darwin: macOS システム設定（Homebrew統合含む）
   - Home Manager: ユーザー環境・設定ファイル

2. **Chezmoi層**: dotfiles と個人設定を管理
   - `~/.config/` 以下の設定ファイル
   - Claude Code設定（スキル・エージェント定義）

### ディレクトリ構造

- `nix/`: Nix flake設定
  - `flake.nix`: メイン設定（パッケージ、Homebrew、Home Manager）
  - `init.zsh`: Home Manager管理のzsh初期化スクリプト
- `chezmoi/`: dotfiles管理ディレクトリ（Chezmoi source）
  - `exact_dot_config/`: `~/.config/` 配下の設定
  - `exact_dot_claude/`: Claude Code設定
  - `.chezmoi.toml.tmpl`: Chezmoiテンプレート設定
- `Taskfile.yml`: タスク定義（go-task）

### パッケージ管理戦略

現在、以下の優先順位でパッケージを管理：

1. **Nix Packages（推奨）**: `nix/flake.nix` の `home.packages` で宣言
   - 例: nixfmt, statix, mise, sheldon, starship, Rust toolchain

2. **Homebrew（移行中）**: `homebrew.brews` および `homebrew.casks`
   - 理由: Nixでのビルドが困難、バイナリのみ提供、macOS特化ツール
   - 長期目標: 可能な限りNixへ移行

### 設定の適用フロー

1. `nix/flake.nix` でパッケージ・システム設定を宣言
2. `task darwin-switch` で nix-darwin 適用（Homebrew統合含む）
3. `chezmoi apply` で dotfiles を `$HOME` 配下に展開
4. zsh起動時に `init.zsh` で sheldon/starship を初期化

### 重要な設定ファイル

- `nix/flake.nix:52-54`: ユーザーホームディレクトリ定義（nix-darwin の必須設定）
- `nix/flake.nix:187-189`: zsh の initExtra で init.zsh を読み込み
- `.chezmoiroot`: Chezmoi のソースディレクトリを `chezmoi/` に指定
- `chezmoi/exact_dot_config/exact_sheldon/plugins.toml`: zsh プラグイン管理
- `chezmoi/exact_dot_config/exact_mise/config.toml`: 言語バージョン管理

### トラブルシューティング

- **nix-darwin適用エラー**: ホスト名が一致しているか確認（`hostname` コマンドで確認、`flake.nix:29` と一致させる）
- **Chezmoi適用時の競合**: `chezmoi diff` で差分確認後、必要に応じて `chezmoi merge <file>` で手動マージ
- **Homebrewとの競合**: Nixパッケージを優先、Homebrewは補完的に使用