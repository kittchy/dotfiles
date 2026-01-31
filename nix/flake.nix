{
  description = "A flake to provision my environment";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
    }:

    let
      hostname = "kiuchitakahirononotobukkukonpyuta";
      username = "kiuchitakahiro";
      system = "aarch64-darwin";
      homedir = "/Users/${username}";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      darwinConfigurations = {
        "${hostname}" = nix-darwin.lib.darwinSystem {
          inherit system pkgs;

          modules = [
            {
              nix.enable = false;
              system = {
                stateVersion = 5;
                defaults.controlcenter.BatteryShowPercentage = true;
                primaryUser = "kiuchitakahiro";
              };

              # Define user home directory for nix-darwin
              users.users."${username}" = {
                home = homedir;
              };

              homebrew = {
                enable = true;
                # TODO: nix packageに移行
                # 移行したらhomebrew から削除
                brews = [
                  "awscli" # AWS Command Line Interface
                  "bakks/bakks/butterfish" # LLM統合シェルツール (AI支援コマンドライン)
                  "bastet" # 意地悪なテトリスゲーム (最悪のブロックを選ぶAI)
                  "chezmoi" # dotfiles管理ツール
                  "cmake" # クロスプラットフォームビルドシステム
                  "cocoapods" # Swift/Objective-C依存関係管理
                  "cryptography" # Python暗号化ライブラリ
                  "devcontainer" # VS Code Dev Containers CLI
                  "docker" # コンテナプラットフォーム
                  "docker-compose" # Docker複数コンテナ管理
                  "docker-credential-helper" # Docker認証情報ヘルパー
                  "duf" # ディスク使用量表示ツール (df/duの改良版)
                  "fd" # find代替高速ファイル検索
                  "ffind" # ファイル検索ツール
                  "ffmpeg" # 動画/音声変換ツール
                  "fish" # フレンドリーな対話型シェル
                  "fzf" # コマンドラインファジーファインダー
                  "gcc" # GNU Compiler Collection
                  "gemini-cli" # Google Gemini CLI (AI支援ターミナルツール)
                  "gh" # GitHub CLI
                  "ghostscript" # PostScript/PDFインタープリタ
                  "git" # 分散バージョン管理システム
                  "git-secrets" # 機密情報検出ツール
                  "go-task/tap/go-task" # タスクランナー (Makefileの代替)
                  "hashicorp/tap/terraform" # Infrastructure as Code
                  "htop" # インタラクティブなプロセスビューア
                  "hugo" # 静的サイトジェネレーター
                  "imagemagick" # 画像処理ツール
                  "jq" # JSON処理コマンドラインツール
                  "k9s" # Kubernetes TUI (ターミナルUI)
                  "kdoctor" # Kotlin Multiplatform環境診断ツール
                  "kind" # Kubernetes in Docker (ローカルK8sクラスタ)
                  "kubernetes-cli" # kubectl (Kubernetesコマンドラインツール)
                  "lazydocker" # Docker TUI (ターミナルUI)
                  "lazygit" # Git TUI (ターミナルUI)
                  "libsixel" # sixelグラフィックライブラリ
                  "llvm" # LLVMコンパイラインフラストラクチャ
                  "mongocli" # MongoDB CLI
                  "mongodb-atlas-cli" # MongoDB Atlas CLI
                  "mongodb/brew/mongodb-community" # MongoDBデータベース
                  "mongodb/brew/mongodb-community-shell" # MongoDB Shell
                  "neofetch" # システム情報表示ツール
                  "nload" # ネットワーク帯域幅リアルタイムモニター
                  "nsnake" # ターミナルスネークゲーム
                  "nvm" # Node.jsバージョン管理
                  "pigz" # 並列gzip (高速圧縮)
                  "pipx" # Pythonアプリケーション隔離実行
                  "pkgconf" # pkg-config実装
                  "pv" # パイプビューア (進捗表示)
                  "qmk/qmk/qmk" # QMKキーボードファームウェア開発ツール
                  "samtay/tui/tetris" # ターミナルテトリスゲーム
                  "shellcheck" # シェルスクリプト静的解析
                  "sox" # 音声処理ツール
                  "speedtest-cli" # インターネット回線速度測定
                  "svg2png" # SVGからPNG変換ツール
                  "switchaudio-osx" # macOS音声出力切り替え
                  "tmux" # ターミナルマルチプレクサ
                  "tnk-studio/tools/lazykube" # Kubernetes TUI (マウス操作対応)
                  "tree" # ディレクトリツリー表示
                  "tty-clock" # ターミナル時計
                  "twty" # Twitter CLIクライアント
                  "watch" # コマンド定期実行
                  "wget" # ファイルダウンロードツール
                  "wireguard-tools" # WireGuard VPNツール
                  "yarn" # JavaScriptパッケージマネージャー
                  "yazi" # ターミナルファイルマネージャー
                  "youplot" # ターミナルデータプロット/可視化
                  "zellij" # Rustベースターミナルマルチプレクサ
                  "zlib" # 圧縮ライブラリ
                  "neovim" # neovim
                ];
                casks = [
                  "1password"
                  "1password-cli"
                  "arc"
                  "cursor"
                  "font-fira-code"
                  "font-hack-nerd-font"
                  "font-hackgen"
                  "gcloud-cli"
                  "ghostty"
                  "google-chrome"
                  "google-cloud-sdk"
                  "kdenlive"
                  "kindle"
                  "meetingbar"
                  "postman"
                  "rancher"
                  "raycast"
                  "sf-symbols"
                  "slack"
                  "spotify"
                  "via"
                  "vpn-by-google-one"
                  "wezterm"
                  "google-cloud-sdk"
                ];
              };
            }
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."${username}" = {
                  home = {
                    stateVersion = "25.05";
                    inherit username;
                    homeDirectory = homedir;
                    packages = [
                      # TODO: 徐々にhomebrewからnix packageに移行
                      pkgs.nixfmt
                      pkgs.statix
                      pkgs.mise
                      pkgs.sheldon
                      pkgs.starship

                      # Rust 環境の追加
                      pkgs.cargo
                      pkgs.rustc
                      pkgs.rust-analyzer # エディタ補完用（推奨）
                      pkgs.clippy # Linter（推奨）

                    ];
                  };

                  programs.zsh = {
                    enable = true;
                    initExtra = builtins.readFile ./init.zsh;
                  };
                };
              };
            }
          ];
        };
      };
    };
}
