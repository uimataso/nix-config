{ config, pkgs, lib, ... }:

{
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
    # # TODO: move lang stuff out
    # CARGO_HOME = "${config.xdg.dataHome}/cargo";
    PAGER = lib.mkDefault "nvim +Man!";
    MANPAGER = lib.mkDefault "nvim +Man!";
  };

  # Git pager
  programs.git.extraConfig = {
    core.pager = "nvim -R";
    color.pager = false;
  };
}
