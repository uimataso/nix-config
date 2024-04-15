{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.programs.neovim;

  ifImpermanence = attrs: attrsets.optionalAttrs config.myConfig.system.impermanence.enable attrs;
in
{
  options.myConfig.programs.neovim = {
    enable = mkEnableOption "neovim";
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

    home.sessionVariables = {
      # TODO: move lang stuff out
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      PAGER = lib.mkDefault "nvim +Man!";
      MANPAGER = lib.mkDefault "nvim +Man!";
    };

    # Git pager
    programs.git.extraConfig = {
      core.pager = "nvim -R";
      color.pager = false;
    };

    # TODO: maybe i can try out vim.nix?
    home.persistence.main = ifImpermanence {
      directories = [
        ".cache/nvim"
        ".local/share/nvim"
        ".local/state/nvim"
      ];
    };
  };
}
