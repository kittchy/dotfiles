# Dotfiles & Development Environment

macOS向けの宣言的な開発環境管理リポジトリ。Nix + nix-darwin + Home Managerによるパッケージ・システム設定管理と、Chezmoiによるdotfiles管理を採用しています。

## 特徴

- **宣言的環境管理**: Nix Flakesによる再現可能な環境構築
- **統合パッケージ管理**: Nix Packages + Homebrew（補完的）
- **dotfiles自動化**: Chezmoiによるテンプレート対応のdotfiles管理
- **タスクランナー統合**: go-taskによる操作の簡素化

## 前提条件

以下のツールが必要です：

1. **Nix**: [Determinate Systems Nix Installer](https://github.com/DeterminateSystems/nix-installer)を推奨
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
   ```

2. **go-task**: タスクランナー
   ```bash
   brew install go-task
   ```

3. **chezmoi**: dotfiles管理（Nixでインストール可能）
   ```bash
   nix profile install nixpkgs#chezmoi
   ```

## セットアップ

### 初回セットアップ

```bash
# 1. リポジトリをクローン
git clone <this-repo-url> ~/dotfile
cd ~/dotfile

# 2. nix-darwin環境を適用
task darwin-switch

# 3. dotfilesを適用
task chezmoi_initialize
chezmoi apply
```

### 日常的な操作

```bash
# パッケージ追加後の適用
task darwin-switch

# dotfilesの更新
chezmoi apply

# flake依存の更新
task update
task darwin-switch

# ガベージコレクション
task clean
```

## 設定管理

### パッケージ追加

#### Nixパッケージ（推奨）

`nix/flake.nix` の `home.packages` に追加：

```nix
home.packages = [
  pkgs.package-name  # 追加したいパッケージ
];
```

パッケージ検索: <https://search.nixos.org/packages>

#### Homebrewパッケージ

`nix/flake.nix` の `homebrew.brews` または `homebrew.casks` に追加：

```nix
homebrew = {
  brews = [ "package-name" ];
  casks = [ "app-name" ];
};
```

※ 長期的にはNixへ移行推奨

### dotfilesの追加・編集

```bash
# ファイルをChezmoiで管理
chezmoi add ~/.config/newfile

# 編集（エディタで開く）
chezmoi edit ~/.config/newfile

# 差分確認
chezmoi diff

# 適用
chezmoi apply
```

### システム設定

macOSのシステム設定は `nix/flake.nix` の `system.defaults` セクションで管理：

```nix
system.defaults = {
  controlcenter.BatteryShowPercentage = true;
  # 他の設定...
};
```

## ディレクトリ構造

```
dotfile/
├── nix/                   # Nix設定
│   ├── flake.nix         # メインFlake（パッケージ・システム設定）
│   ├── flake.lock        # 依存関係ロックファイル
│   └── init.zsh          # zsh初期化スクリプト
├── chezmoi/              # Chezmoiソースディレクトリ
│   ├── exact_dot_config/ # ~/.config/ 配下の設定
│   ├── exact_dot_claude/ # Claude Code設定
│   ├── dot_*.zsh         # dotfiles（. プレフィックス）
│   └── .chezmoi.toml.tmpl # Chezmoiテンプレート設定
├── Taskfile.yml          # タスク定義
├── .chezmoiroot          # Chezmoiソースディレクトリ指定
└── README.md             # このファイル
```

## タスク一覧

```bash
# nix-darwin設定の適用
task darwin-switch

# flake依存の更新
task update

# flake設定のチェック
task check

# ガベージコレクション
task clean

# Chezmoi初期化
task chezmoi_initialize
```

## トラブルシューティング

### ホスト名不一致エラー

```bash
# 現在のホスト名を確認
hostname

# nix/flake.nix の hostname 変数を一致させる
# 例: let hostname = "your-hostname-here"; in
```

### Homebrewとの競合

Nixパッケージが優先されます。同じパッケージをHomebrewとNixの両方で管理しないでください。

### Chezmoi適用時の競合

```bash
# 差分確認
chezmoi diff

# 手動マージ
chezmoi merge <file>

# 強制適用（注意）
chezmoi apply --force
```

## 参考リンク

- [Nix公式ドキュメント](https://nixos.org/manual/nix/stable/)
- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [Home Manager](https://github.com/nix-community/home-manager)
- [Chezmoi](https://www.chezmoi.io/)
- [go-task](https://taskfile.dev/)
