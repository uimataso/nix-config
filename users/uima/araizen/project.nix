{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Project dependency
    rustc
    cargo
    rust-analyzer
    rustfmt
    clippy
    sqlx-cli
    cargo-nextest
    cargo-machete
    gnumake
    awscli2

    # With `env.{OPENSSL_DEV, PKG_CONFIG_PATH}` to fix ssl issue
    libiconv
    openssl
    pkg-config
  ];

  home.sessionVariables = {
    OPENSSL_DEV = pkgs.openssl.dev;
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };
}
