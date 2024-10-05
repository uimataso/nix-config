{
  description = "{{NAME}}";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
      pkgsFor = nixpkgs.legacyPackages;
    in
    rec {
      packages = forAllSystems (system: {
        default = pkgsFor.${system}.rustPlatform.buildRustPackage {
          pname = "{{CODENAME}}";
          version = "0.1.0";

          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
        };
      });

      devShells = forAllSystems (system: {
        default = packages.${system}.default.overrideAttrs (oa: {
          nativeBuildInputs =
            with pkgsFor.${system};
            [
              # Additional rust tooling
              rust-analyzer
              rustfmt
              clippy
            ]
            ++ (oa.nativeBuildInputs or [ ]);
        });
      });
    };
}
