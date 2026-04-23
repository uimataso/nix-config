{
  description = "{{NAME}}";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      nixpkgs,
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
            }
          )
        );
    in
    {
      packages = forAllSystems (pkgs: {
        default = pkgs.buildGoModule {
          pname = "{{CODENAME}}";
          version = "0.1.0";
          src = ./.;
          vendorHash = null;
          buildInputs = [
          ];
        };
      });

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            go
          ];
        };
      });
    };
}
