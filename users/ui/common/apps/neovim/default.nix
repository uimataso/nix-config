{ config, pkgs, ... }:

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

  # home.file.".config/nvim".source = ./.;
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/users/ui/common/apps/neovim";

  home.sessionVariables = {
    EDITOR = "nvim";

    PAGER = "nvim +Man!";
    MANPAGER = "nvim +Man!";

    # TODO: move this out
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
  };

  # Git pager
  programs.git.extraConfig = {
    core.pager = "nvim -R";
    color.pager = false;
  };
}
