{
  description = "{{NAME}}";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            (rust-bin.fromRustupToolchainFile ./rust-toolchain.toml)

            openssl
            pkg-config
          ];

          shellHook = ''
            export OPENSSL_DEV=${pkgs.openssl.dev};
            export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig";
          '';
        };

        packages.default = pkgs.rustPlatform.buildRustPackage {
          pname = "{{CODENAME}}";
          version = "0";
          src = ./.;
          cargoLock = {
            lockFile = ./Cargo.lock;
          };
        };

        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.default;
        };
      }
    );
}
