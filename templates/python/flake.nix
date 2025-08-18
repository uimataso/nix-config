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
        pythonPkgs = pkgs.python313Packages;
      in
      {
        # https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/python.section.md#buildpythonpackage-function-buildpythonpackage-function
        packages.default = pythonPkgs.buildPythonPackage {
          pname = "{{CODENAME}}";
          version = "0.1.0";
          pyproject = true;

          src = ./.;

          build-system = [ pythonPkgs.hatchling ];

          dependencies = with pythonPkgs; [
            # Python dependencies
            numpy
          ];

          buidInputs = with pkgs; [
            # Non Python dependencies
          ];
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.default ];

          buildInputs = [
            pythonPkgs.python-lsp-server
            pkgs.black
          ];
        };
      }
    );
}
