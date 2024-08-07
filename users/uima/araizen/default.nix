{ config, pkgs, pkgs-stable, lib, inputs, ... }:

{
  home.username = "uima";

  home.stateVersion = "23.11";

  home.packages = (with pkgs; [
    fd
    scripts.extract
  ]) ++ (with pkgs-stable; [
    # Project dependencies, bc I don't want to use flake there
    rustc
    cargo
    rust-analyzer
    rustfmt
    clippy
    cargo-nextest
    sqlx-cli
    awscli2

    libiconv
    openssl
    pkg-config
  ]);

  # NOTE: try to fix openssl issue when `cargo test`, these variables are necessary needed, idk why
  home.sessionVariables = {
    OPENSSL_DEV = pkgs-stable.openssl.dev;
    PKG_CONFIG_PATH="${pkgs-stable.openssl.dev}/lib/pkgconfig";
  };

  programs = {
    htop.enable = true;
    btop.enable = true;
    ripgrep.enable = true;
    jq.enable = true;
    bat.enable = true;
    ssh.extraConfig = ''
      Host github.com
        HostName github.com
        IdentityFile ~/.ssh/id_ed25519_uima_chen
        IdentitiesOnly yes

      Host github-personal
        HostName github.com
        IdentityFile ~/.ssh/id_ed25519
        IdentitiesOnly yes
    '';
  };

  uimaConfig = {
    global.enable = true;

    system = {
      xdg.enable = true;
      xdg-user-dirs.enable = true;
    };

    sh = {
      bash.enable = true;
      # bash.defaultShell = true;
      nushell.enable = true;
      nushell.defaultShell = true;
    };

    sh-util = {
      fzf.enable = true;
      fff.enable = true;
      eza.enable = true;
      tmux.enable = true;
      tealdeer.enable = true;
    };

    dev = {
      direnv.enable = true;
      git = {
        enable = true;
        name = "Uima";
        email = "uima.chen@araizen.com";
      };
      lazygit.enable = true;
    };

    programs = {
      neovim.enable = true;
      neovim.defaultEditor = true;

      ssh.enable = true;
    };
  };
}
