{
  description = "uima's nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    # nixpkgs-local.url = "git+file:///home/uima/src/nixpkgs";

    # vimium-options.url = "git+file:///home/uima/src/vimium-nixos";
    vimium-options.url = "github:uimataso/vimium-nixos";

    # Misc
    systems.url = "github:nix-systems/default-linux";
    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    # Basic
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };

    # System
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

    # User Space
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    arkenfox = {
      url = "github:dwarfmaster/arkenfox-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      systems,
      treefmt-nix,
      ...
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

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = forAllSystems (system: treefmt-nix.lib.evalModule nixpkgsFor.${system} ./treefmt.nix);

      # SpecialArgs that share between nixosConfig and homeConfig
      specialArgs = forAllSystems (system: {
        inherit self inputs outputs;
        pkgs-stable = (inputPkgsFor inputs.nixpkgs-stable).${system};
        # pkgs-local = (inputPkgsFor inputs.nixpkgs-local).${system};
      });

      nixosConfig =
        { modules, system }:
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

      homeConfig =
        { modules, system }:
        lib.homeManagerConfiguration {
          pkgs = nixpkgsFor.${system};
          extraSpecialArgs = specialArgs.${system};
          modules = modules ++ [ outputs.homeManagerModules ];
        };
    in
    {
      inherit lib;

      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        uifw = nixosConfig {
          modules = [ ./hosts/uifw ];
          system = "x86_64-linux";
        };
      };

      overlays = import ./overlays { inherit inputs outputs; };
      packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgsFor.${system}; });

      templates = import ./templates;

      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);

      devShells = forAllSystems (
        system:
        import ./shell.nix {
          pkgs = nixpkgsFor.${system};
          pre-commit-check = self.checks.${system}.pre-commit-check;
        }
      );

      checks = forAllSystems (system: {
        formatting = treefmtEval.${system}.config.build.check self;
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            # treefmt.enable = true;
          };
        };
      });
    };
}
