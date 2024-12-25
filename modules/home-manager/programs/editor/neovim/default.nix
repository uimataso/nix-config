{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkIf mkEnableOption mkOption types;
  cfg = config.uimaConfig.programs.editor.neovim;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.editor.neovim = {
    enable = mkEnableOption "neovim";

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = "Use neovim as default editor";
    };
  };

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable {
      directories = [
        ".cache/nvim"
        ".local/share/nvim"
        ".local/state/nvim"
      ];
    };

    uimaConfig.programs.editor = mkIf cfg.defaultEditor {
      enable = true;
      executable = "nvim";
    };

    home.packages = with pkgs; [
      neovim
      gcc

      fd
      ripgrep
      delta

      # LSP / Formatter
      # Generic Formatter
      prettierd
      typos-lsp

      # Lua
      lua-language-server
      stylua

      # Shell
      shellcheck
      bash-language-server

      # Nix
      nil
      nixd

      # Rust
      rust-analyzer
      rustfmt
      clippy
      cargo-nextest

      # C/Cpp
      clang-tools

      # Yaml
      yaml-language-server
      yamlfmt

      # OpenAPI
      vacuum-go

      # Typescript
      typescript-language-server
    ];

    xdg.configFile = {
      "nvim".source = ./.;
    };

    home.sessionVariables = {
      # PAGER = lib.mkDefault "nvim +Man!";
      # MANPAGER = "nvim -c Man! -c 'set signcolumn=no'";
      MANPAGER = "nvim -c Man!";
      MANWIDTH = 1000000;
    };

    # Git pager
    programs.git.extraConfig = {
      core.pager = "nvim -R";
      color.pager = false;
    };
  };
}
