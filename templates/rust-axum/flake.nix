{
  description = "{{NAME}}";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    naersk.url = "github:nix-community/naersk";
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      nixpkgs,
      naersk,
      rust-overlay,
      ...
    }:
    let
      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      forAllSystems =
        function:
        nixpkgs.lib.genAttrs systems (
          system:
          function (
            import nixpkgs {
              inherit system;
              overlays = [ (import rust-overlay) ];
            }
          )
        );
    in
    {
      packages = forAllSystems (
        pkgs:
        let
          naersk' = pkgs.callPackage naersk { };
          server = naersk'.buildPackage {
            src = ./.;
            nativeBuildInputs = with pkgs; [ pkg-config ];
            buildInputs = with pkgs; [ openssl ];
          };
        in
        {
          server = server;

          server-image = pkgs.dockerTools.buildImage {
            name = "{{CODENAME}}";
            tag = "latest";

            copyToRoot = pkgs.buildEnv {
              name = "image-root";
              pathsToLink = [ "/bin" ];
              paths = [
                server
                pkgs.curl
                pkgs.bashInteractive
                pkgs.coreutils
              ];
            };

            config = {
              Cmd = [ "/bin/{{CODENAME}}" ];
              ExposedPorts = {
                "8080/tcp" = { };
              };
            };
          };

        }
      );

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            (rust-bin.stable.latest.default.override {
              extensions = [
                "rust-analyzer"
                "rust-std"
                "rust-src"
              ];
            })

            openssl
            pkg-config
          ];

          shellHook = ''
            export OPENSSL_DEV=${pkgs.openssl.dev};
            export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig";
          '';
        };
      });
    };
}
