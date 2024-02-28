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
  ];

  home.file.".config/nvim".source = ./.;

  home.sessionVariables = {
    EDITOR = "nvim";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
  };
}
