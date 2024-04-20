{ config, lib, pkgs, ... }:

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
    home.packages = with pkgs; [
      neovim

      ripgrep

      shellcheck
      nodePackages.bash-language-server

      libclang
      # codelldb
      lua-language-server
      stylua
    ];

    home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink ./.;

    home.sessionVariables = mkMerge [
      {
        # TODO: move lang stuff out
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
        PAGER = lib.mkDefault "nvim +Man!";
        MANPAGER = lib.mkDefault "nvim +Man!";
      }
      (mkIf cfg.defaultEditor {
        EDITOR = "nvim";
      })
    ];


    # Git pager
    programs.git.extraConfig = {
      core.pager = "nvim -R";
      color.pager = false;
    };

    # TODO: maybe i can try out vim.nix?
    home.persistence.main = mkIf imper.enable {
      directories = [
        ".cache/nvim"
        ".local/share/nvim"
        ".local/state/nvim"
      ];
    };
  };
}
