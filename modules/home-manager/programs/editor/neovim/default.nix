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

      # For rest.nvim
      luarocks
      lua51Packages.lua
      # For Telescope
      ripgrep

      # Lua LSP
      lua-language-server
      stylua

      # Shell LSP
      shellcheck
      bash-language-server

      # Nix LSP (bc we on NixOS!)
      nil
      nixd
    ];

    xdg.configFile = {
      "nvim" = {
        source = ./.;
        # make lazy.lock outof control
        recursive = true;
      };
    };

    home.sessionVariables = {
      # PAGER = lib.mkDefault "nvim +Man!";
      MANPAGER = lib.mkDefault "nvim +Man!";
    };

    # Git pager
    programs.git.extraConfig = {
      core.pager = "nvim -R";
      color.pager = false;
    };
  };
}
