# FIXME: THIS IS NOT WORKABLE!!!

{
  description = "{{NAME}}";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python313;
        pythonPkgs = pkgs.python313Packages;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.uv
            python

            pythonPkgs.python-lsp-server
            pkgs.black

            pythonPkgs.fastapi-cli
          ];
        };
      }
    );
}
