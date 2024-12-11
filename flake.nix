{
  description = "uima's nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    # nixpkgs-local.url = "git+file:///home/uima/src/nixpkgs";

    systems.url = "github:nix-systems/default-linux";

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
    arkenfox.inputs.nixpkgs.follows = "nixpkgs";

    nixcord.url = "github:kaylorben/nixcord";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , systems
    , ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;

      # Generate attrset for each system
      forAllSystems = lib.genAttrs (import systems);

      inputPkgsFor =
        pkgs:
        forAllSystems (
          system:
          import pkgs {
            inherit system;
            config.allowUnfree = true;
          }
        );

      # Nixpkgs for each system
      nixpkgsFor = inputPkgsFor nixpkgs;

      # SpecialArgs that share between nixosConfig and homeConfig
      specialArgs = forAllSystems (system: {
        inherit inputs outputs;
        pkgs-stable = (inputPkgsFor inputs.nixpkgs-stable).${system};
        # pkgs-local = (inputPkgsFor inputs.nixpkgs-local).${system};
      });

      nixosConfig = { modules, system }:
        lib.nixosSystem {
          pkgs = nixpkgsFor.${system};
          specialArgs = specialArgs.${system};

          modules = modules ++ [
            outputs.nixosModules
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                sharedModules = [ outputs.homeManagerModules ];
                extraSpecialArgs = specialArgs.${system};
              };
            }
          ];
        };

      homeConfig = { modules, system }:
        lib.homeManagerConfiguration {
          pkgs = nixpkgsFor.${system};
          extraSpecialArgs = specialArgs.${system};
          modules = modules ++ [
            outputs.homeManagerModules
          ];
        };
    in
    {
      inherit lib;

      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        uicom = nixosConfig {
          modules = [ ./hosts/uicom ];
          system = "x86_64-linux";
        };

        araizen = nixosConfig {
          modules = [ ./hosts/araizen ];
          system = "x86_64-linux";
        };
      };

      # TODO: not tested yet
      homeConfigurations = {
        "uima@uicom" = homeConfig {
          modules = [ ./users/uima/uicom ];
          system = "x86_64-linux";
        };
      };

      overlays = import ./overlays { inherit inputs outputs; };
      packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgsFor.${system}; });

      templates = import ./templates;

      # NOTE: use `pre-commit run --all-files`, see [this issue](https://github.com/cachix/git-hooks.nix/issues/287)
      # formatter = forAllSystems (system: pkgsFor.${system}.nixfmt-rfc-style);
      devShells = forAllSystems (
        system:
        import ./shell.nix {
          pkgs = nixpkgsFor.${system};
          pre-commit-check = self.checks.${system}.pre-commit-check;
        }
      );
      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
          };
        };
      });
    };
}
