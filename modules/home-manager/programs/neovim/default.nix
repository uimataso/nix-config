{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.programs.neovim;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.neovim = {
    enable = mkEnableOption "neovim";

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = "Use neovim as default editor";
    };
  };

  config = mkIf cfg.enable {
    # TODO: Learn `g;`, `[]` commands, marks, quicklist, register

    home.packages = with pkgs; [
      neovim

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
      "nvim".source = config.lib.file.mkOutOfStoreSymlink ./.;
    };

    home.sessionVariables = mkMerge [
      {
        # PAGER = lib.mkDefault "nvim +Man!";
        MANPAGER = lib.mkDefault "nvim +Man!";
      }
      (mkIf cfg.defaultEditor { EDITOR = "nvim"; })
    ];

    # Git pager
    programs.git.extraConfig = {
      core.pager = "nvim -R";
      color.pager = false;
    };

    home.persistence.main = mkIf imper.enable {
      directories = [
        ".cache/nvim"
        ".local/share/nvim"
        ".local/state/nvim"
      ];
    };
  };
}
