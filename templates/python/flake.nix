{
  description = "{{NAME}}";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    poetry2nix.url = "github:nix-community/poetry2nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      poetry2nix,
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
      pkgsFor = nixpkgs.legacyPackages;
    in
    rec {
      packages = forAllSystems (system: {
        default = pkgsFor.${system}.python311Packages.buildPythonApplication {
          pname = "{{CODENAME}}";
          version = "0.1.0";
          # format = "pyproject";

          src = ./.;

          propagatedBuildInputs = with pkgsFor.${system}; [ python311Packages.setuptools ];
        };
      });

      devShells = forAllSystems (system: {
        default = pkgsFor.${system}.packages.default.overrideAttrs (oa: {
          nativeBuildInputs =
            with pkgsFor.${system};
            [ python311Packages.python-lsp-server ] ++ (oa.nativeBuildInputs or [ ]);
        });
      });
    };
}
