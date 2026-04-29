# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 概要

macOS / Linux 向けの dotfiles と開発環境管理リポジトリ。Nix Flakes（nix-darwin + Home Manager）による宣言的な環境構築と、Chezmoi による dotfiles 管理を組み合わせています。

## よく使用されるコマンド

### Nix 環境管理（go-task 経由）

```bash
# プラットフォーム自動判定で適用（macOS なら darwin-switch、Linux なら home-switch）
task switch

# nix-darwin 設定の適用（macOS）
task darwin-switch

# Home Manager 設定の適用（Linux）
task home-switch

# flake 依存の更新
task update

# flake 設定のチェック
task check

# ガベージコレクション
task clean
```

`darwin-switch` / `home-switch` は内部で `--impure` を付けつつ `NIX_DARWIN_HOSTNAME` / `USER` を環境変数で渡してから flake を評価します（`Taskfile.yml` 参照）。直接実行する場合も同じ環境変数が必要です。

### Chezmoi（dotfiles 管理）

```bash
# 初回適用（$HOME/dotfiles を source とする chezmoi init）
task chezmoi_initialize

# dotfiles の適用 / 差分確認 / 追加 / 取得＋適用
chezmoi apply
chezmoi diff
chezmoi add <file>
chezmoi update
```

## アーキテクチャ

### 環境管理の二層構造

1. **Nix 層**: システム・ユーザーパッケージとサービスを宣言的に管理
   - `nix-darwin`: macOS システム設定（`system.defaults` や Homebrew 統合を含む）
   - `home-manager`: ユーザー環境・shell・パッケージ
2. **Chezmoi 層**: dotfiles と個人設定（`~/.config/`、`~/.claude/` 等）をテンプレートとして管理

Nix 層が「環境（パッケージ・shell・OS 設定）」、Chezmoi 層が「設定ファイルの中身」を担う、という責務分離になっています。

### マルチプラットフォーム構成

`nix/flake.nix` は単一の `sharedHomeConfig` を macOS と Linux の両方で再利用する構造です（`flake.nix:70` 付近で定義）。

- macOS: `darwinConfigurations."${darwinHostname}"` を `nix-darwin.lib.darwinSystem` で構築（Homebrew はここで統合）
- Linux: `homeConfigurations."${linuxUsername}"` を standalone Home Manager で構築（`xclip` 等の Linux 固有パッケージのみ追加）

ホスト名・ユーザー名は flake 評価時に環境変数（`NIX_DARWIN_HOSTNAME` / `SUDO_USER` / `USER`）から取得するため、`--impure` 付きで実行する必要があります。`Taskfile.yml` のタスクから呼ぶ限りは自動的に付与されます。

### ディレクトリ構造

- `nix/`: Nix flake 設定
  - `flake.nix`: メイン設定（共通 Home Manager 設定、nix-darwin、Homebrew、Linux Home Manager）
  - `init.zsh`: zsh 起動時の追加スクリプト（Home Manager の `programs.zsh.initContent` として読み込む）
  - `flake.lock`: 依存ロック
- `chezmoi/`: Chezmoi の source ディレクトリ（`.chezmoiroot` で指定）
  - `dot_config/`: `~/.config/` 配下（git, nvim, sheldon, mise, ghostty, wezterm, zellij, zsh など）
  - `dot_claude/`: Claude Code 設定（`agents/`, `skills/`, `settings.json`, `CLAUDE.md`）
  - `dot_mcp.json`, `dot_p10k.zsh`, `dot_latexmkrc`: ドットファイル群
  - `.chezmoi.toml.tmpl`: Chezmoi テンプレート設定
  - `.chezmoiignore`: 適用除外パターン
- `Taskfile.yml`: go-task のタスク定義
- `.chezmoiroot`: Chezmoi の source を `chezmoi/` に固定

### パッケージ管理戦略

優先順位は以下の通り:

1. **Nix Packages（推奨）**: `nix/flake.nix` の `sharedHomeConfig` 内 `home.packages` で宣言（CLI ツール、Rust toolchain、neovim、chezmoi など共通ツール）。プラットフォーム固有のものは `darwinConfigurations` / `homeConfigurations` 側に追加。
2. **Homebrew（macOS のみ・移行中）**: Nix でビルドが困難 / バイナリ提供のみ / macOS 特化の GUI アプリは `homebrew.brews` / `homebrew.casks`（`flake.nix:156` 付近）で管理。長期目標は Nix への寄せ。

`config.allowUnfreePredicate` で個別に許可する unfree パッケージは `flake.nix:46` 付近のリストに追記します。

### 設定の適用フロー

1. `nix/flake.nix` でパッケージ・システム設定を宣言
2. `task switch`（または `darwin-switch` / `home-switch`）で nix-darwin / Home Manager を適用（macOS では Homebrew 統合も同時に走る）
3. `chezmoi apply` で dotfiles を `$HOME` 配下に展開
4. zsh 起動時、Home Manager 経由の `init.zsh` が `sheldon` / `starship` 等を初期化

### 重要な参照ポイント

- `nix/flake.nix:33` 付近: `NIX_DARWIN_HOSTNAME` を読み取るホスト名解決
- `nix/flake.nix:70` 付近: `sharedHomeConfig` 共通 Home Manager 設定
- `nix/flake.nix:126` 付近: `programs.zsh.initContent = builtins.readFile ./init.zsh`
- `nix/flake.nix:152` 付近: `users.users."${darwinUsername}".home`
- `nix/flake.nix:156` 付近: Homebrew brews/casks
- `chezmoi/dot_config/sheldon/plugins.toml`: zsh プラグイン管理
- `chezmoi/dot_config/mise/config.toml`: 言語ランタイムバージョン管理

行番号は flake 編集で頻繁にずれるので、参照する前に `grep -n` で再確認してください。

### トラブルシューティング

- **`darwinHostname` が空 / マッチしない**: `task darwin-switch` 経由なら `NIX_DARWIN_HOSTNAME=$(hostname -s)` が自動で渡る。直接 `nix run nix-darwin -- switch --flake ./nix#<host>` するときは `--impure` と `NIX_DARWIN_HOSTNAME` を自分でセットする。
- **Chezmoi 適用時の競合**: `chezmoi diff` で差分確認 → `chezmoi merge <file>` で手動マージ。`--force` は最後の手段。
- **Homebrew と Nix の競合**: 同じパッケージを両方で管理しない（Nix 優先）。Homebrew は macOS 専用 GUI / Nix で扱いにくいバイナリの補完用途に限定。
