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
    python310Packages.python-lsp-server

    cargo
    rust-analyzer
    clippy
    rustfmt
    rustc
  ];

  # home.file.".config/nvim".source = ./.;
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/users/ui/common/apps/neovim";

  home.sessionVariables = {
    EDITOR = "nvim";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
  };
}
