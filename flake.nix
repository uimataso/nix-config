{
  description = "uima's nixos config";

  # TODO: Push extrakto to nixpkgs
  # TODO: Test nix build speed with and without overlays

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    base16.url = "github:SenchoPens/base16.nix";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
    arkenfox.inputs.nixpkgs.follows = "nixpkgs";

    nixcord.url = "github:kaylorben/nixcord";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      pkg-inputs = [
        "nixpkgs"
        "nixpkgs-stable"
      ];

      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.nixpkgs.${system});

      pkgsFor =
        with lib;
        genAttrs pkg-inputs (
          pkg:
          genAttrs systems (
            system:
            import inputs.${pkg} {
              inherit system;
              config.allowUnfree = true;
            }
          )
        );

      nixosConfig =
        { modules, system }:
        let
          specialArgs = {
            inherit inputs outputs;
            pkgs-stable = pkgsFor.nixpkgs-stable.${system};
          };
        in
        lib.nixosSystem {
          inherit specialArgs;
          pkgs = pkgsFor.nixpkgs.${system};

          modules = [
            outputs.nixosModules
            # Import home-manager
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                sharedModules = [ outputs.homeManagerModules ];
                extraSpecialArgs = specialArgs;
              };
            }
          ] ++ modules;
        };
    in
    rec {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays { inherit inputs outputs; };
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });

      formatter = forEachSystem (pkgs: pkgs.nixfmt-rfc-style);
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      templates = import ./templates;

      # FIXME: Github CI: nix eval always stack overflow
      # [](https://github.com/ryan4yin/nix-config/blob/main/.github/workflows/flake_evaltests.yml)
      evalTests."araizen" = nixosConfigurations."araizen".config.system.build.toplevel;

      nixosConfigurations = {
        uicom = nixosConfig {
          modules = [ ./hosts/uicom ];
          system = "x86_64-linux";
        };

        vm-mini = nixosConfig {
          modules = [ ./hosts/vm-mini ];
          system = "x86_64-linux";
        };

        araizen = nixosConfig {
          modules = [ ./hosts/araizen ];
          system = "x86_64-linux";
        };
      };

      # TODO: Make home-manager can be used standalone
      # homeConfigurations = { };
    };
}
