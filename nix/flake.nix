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
      # ========================================
      # macOS Configuration
      # ========================================
      darwinHostname = "kiuchitakahirononotobukkukonpyuta";
      darwinUsername = "kiuchitakahiro";
      darwinSystem = "aarch64-darwin";
      darwinHomedir = "/Users/${darwinUsername}";
      darwinPkgs = import nixpkgs { system = darwinSystem; };

      # ========================================
      # Linux (Ubuntu) Configuration
      # ========================================
      linuxUsername = "kittchy";
      linuxSystem = "x86_64-linux";
      linuxHomedir = "/home/${linuxUsername}";
      linuxPkgs = import nixpkgs { system = linuxSystem; };

      # ========================================
      # Shared Home Manager Configuration
      # ========================================
      sharedHomeConfig = pkgs: username: homedir: {
        home = {
          stateVersion = "25.05";
          inherit username;
          homeDirectory = homedir;
          packages = [
            # Nix tools
            pkgs.nixfmt-classic
            pkgs.statix

            # Shell tools
            pkgs.mise
            pkgs.sheldon
            pkgs.starship

            # Rust toolchain
            pkgs.cargo
            pkgs.rustc
            pkgs.rust-analyzer
            pkgs.clippy

            # CLI tools (shared across platforms)
            pkgs.fzf
            pkgs.fd
            pkgs.ripgrep
            pkgs.jq
            pkgs.htop
            pkgs.tree
            pkgs.wget
            pkgs.git
            pkgs.gh
            pkgs.lazygit
            pkgs.tmux
            pkgs.neovim
            pkgs.chezmoi
          ];
        };

        programs.zsh = {
          enable = true;
          initExtra = builtins.readFile ./init.zsh;
        };
      };

    in
    {
      # ========================================
      # macOS (nix-darwin) Configuration
      # ========================================
      darwinConfigurations = {
        "${darwinHostname}" = nix-darwin.lib.darwinSystem {
          system = darwinSystem;
          pkgs = darwinPkgs;

          modules = [
            {
              nix.enable = false;
              system = {
                stateVersion = 5;
                defaults.controlcenter.BatteryShowPercentage = true;
                primaryUser = darwinUsername;
              };

              users.users."${darwinUsername}" = {
                home = darwinHomedir;
              };

              homebrew = {
                enable = true;
                # macOS-only packages via Homebrew
                brews = [
                  "awscli"
                  "bakks/bakks/butterfish"
                  "bastet"
                  "cmake"
                  "cocoapods"
                  "cryptography"
                  "devcontainer"
                  "docker"
                  "docker-compose"
                  "docker-credential-helper"
                  "duf"
                  "ffind"
                  "ffmpeg"
                  "fish"
                  "gcc"
                  "gemini-cli"
                  "ghostscript"
                  "git-secrets"
                  "go-task/tap/go-task"
                  "hashicorp/tap/terraform"
                  "hugo"
                  "imagemagick"
                  "k9s"
                  "kdoctor"
                  "kind"
                  "kubernetes-cli"
                  "lazydocker"
                  "libsixel"
                  "llvm"
                  "mongocli"
                  "mongodb-atlas-cli"
                  "mongodb/brew/mongodb-community"
                  "mongodb/brew/mongodb-community-shell"
                  "neofetch"
                  "nload"
                  "nsnake"
                  "nvm"
                  "pigz"
                  "pipx"
                  "pkgconf"
                  "pv"
                  "qmk/qmk/qmk"
                  "samtay/tui/tetris"
                  "shellcheck"
                  "sox"
                  "speedtest-cli"
                  "svg2png"
                  "switchaudio-osx"
                  "tnk-studio/tools/lazykube"
                  "tty-clock"
                  "twty"
                  "watch"
                  "wireguard-tools"
                  "yarn"
                  "yazi"
                  "youplot"
                  "zellij"
                  "zlib"
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
                ];
              };
            }
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."${darwinUsername}" = sharedHomeConfig darwinPkgs darwinUsername darwinHomedir;
              };
            }
          ];
        };
      };

      # ========================================
      # Linux (Home Manager Standalone) Configuration
      # ========================================
      homeConfigurations = {
        "${linuxUsername}" = home-manager.lib.homeManagerConfiguration {
          pkgs = linuxPkgs;

          modules = [
            {
              home = {
                stateVersion = "25.05";
                username = linuxUsername;
                homeDirectory = linuxHomedir;
                packages = [
                  # Nix tools
                  linuxPkgs.nixfmt-classic
                  linuxPkgs.statix

                  # Shell tools
                  linuxPkgs.mise
                  linuxPkgs.sheldon
                  linuxPkgs.starship

                  # Rust toolchain
                  linuxPkgs.cargo
                  linuxPkgs.rustc
                  linuxPkgs.rust-analyzer
                  linuxPkgs.clippy

                  # CLI tools
                  linuxPkgs.fzf
                  linuxPkgs.fd
                  linuxPkgs.ripgrep
                  linuxPkgs.jq
                  linuxPkgs.htop
                  linuxPkgs.tree
                  linuxPkgs.wget
                  linuxPkgs.git
                  linuxPkgs.gh
                  linuxPkgs.lazygit
                  linuxPkgs.tmux
                  linuxPkgs.neovim
                  linuxPkgs.chezmoi

                  # Linux-only tools
                  linuxPkgs.xclip
                ];
              };

              programs.zsh = {
                enable = true;
                initExtra = builtins.readFile ./init.zsh;
              };

              # Required for standalone home-manager
              programs.home-manager.enable = true;
            }
          ];
        };
      };
    };
}
