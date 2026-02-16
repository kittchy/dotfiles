{
  description = "A flake to provision my environment";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs?ref=nixos-unstable"; };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, }:

    let
      # ========================================
      # macOS (nix-darwin) Configuration
      # ========================================
      # Get from environment variables (requires --impure flag)
      darwinHostname = builtins.getEnv "NIX_DARWIN_HOSTNAME";
      # Use SUDO_USER if available (when running with sudo), otherwise fall back to USER
      darwinUsername =
        let sudoUser = builtins.getEnv "SUDO_USER";
        in if sudoUser != "" then sudoUser else builtins.getEnv "USER";
      darwinSystem = builtins.currentSystem; # Auto-detect: aarch64-darwin or x86_64-darwin
      darwinHomedir = "/Users/${darwinUsername}";
      darwinPkgs = import nixpkgs { system = darwinSystem; };

      # ========================================
      # Ubuntu Configuration
      # ========================================
      # Get from environment variables (requires --impure flag)
      linuxUsername = builtins.getEnv "USER";
      linuxSystem = builtins.currentSystem; # Auto-detect: x86_64-linux or aarch64-linux
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
            pkgs.nixfmt-rfc-style
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
            pkgs.neovim
            pkgs.chezmoi
            pkgs.sox
            pkgs.tetris
            pkgs.zellij
            pkgs.pv
            pkgs.duf
            pkgs.pigz
            pkgs.yazi
            pkgs.zlib
            pkgs.watch

            # web engine
            pkgs.hugo

            # GUI tools
            pkgs.wezterm
          ];
        };

        programs.zsh = {
          enable = true;
          initExtra = builtins.readFile ./init.zsh;
        };
      };

    in {
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

              users.users.root = { home = "/var/root"; };
              users.users."${darwinUsername}" = { home = darwinHomedir; };

              homebrew = {
                enable = true;
                # macOS-only packages via Homebrew
                brews = [
                  "awscli"
                  "bastet"
                  "cmake"
                  "cocoapods"
                  "cryptography"
                  "devcontainer"
                  "docker"
                  "docker-compose"
                  "docker-credential-helper"
                  "ffmpeg"
                  "gcc"
                  "gemini-cli"
                  "ghostscript"
                  "git-secrets"
                  "go-task/tap/go-task"
                  "hashicorp/tap/terraform"
                  "imagemagick"
                  "k9s"
                  "kdoctor"
                  "kind"
                  "kubernetes-cli"
                  "lazydocker"
                  "libsixel"
                  "llvm"
                  "nload"
                  "nsnake"
                  "pkgconf"
                  "qmk/qmk/qmk"
                  "samtay/tui/tetris"
                  "shellcheck"
                  "speedtest-cli"
                  "svg2png"
                  "switchaudio-osx"
                  "tnk-studio/tools/lazykube"
                  "wireguard-tools"
                ];
                casks = [
                  "1password"
                  "1password-cli"
                  "font-fira-code"
                  "font-hack-nerd-font"
                  "font-hackgen"
                  "gcloud-cli"
                  "google-chrome"
                  "google-cloud-sdk"
                  "meetingbar"
                  "postman"
                  "rancher"
                  "raycast"
                  "sf-symbols"
                  "via"
                  "spotify"
                  "slack"
                ];
              };
            }
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users."${darwinUsername}" =
                  sharedHomeConfig darwinPkgs darwinUsername darwinHomedir;
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
            # Shared configuration (packages, zsh, etc.)
            (sharedHomeConfig linuxPkgs linuxUsername linuxHomedir)

            # Linux-specific additions
            {
              home.packages = [
                linuxPkgs.xclip # Clipboard tool for X11
              ];

              # Required for standalone home-manager on Linux
              programs.home-manager.enable = true;
            }
          ];
        };
      };
    };
}
