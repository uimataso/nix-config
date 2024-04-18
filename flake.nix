{
  description = "My flake";

  # TODO: sops
  # TODO: theme, manage key, programs solution

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";

    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    # nur.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    nix-colors.url = "github:misterio77/nix-colors";

    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
    arkenfox.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;

      systems = [ "x86_64-linux" "aarch64-linux" ];
      pkg-inputs = [ "nixpkgs" "nixpkgs-unstable" ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.nixpkgs.${system});
      pkgsFor = with lib; genAttrs pkg-inputs (pkg:
        genAttrs systems (system: import inputs.${pkg} {
          inherit system;
          config.allowUnfree = true;
        })
      );

      nixosConfig = { modules, system, specialArgs ? { } }: lib.nixosSystem {
        pkgs = pkgsFor.nixpkgs.${system};
        modules = [ ./modules/nixos ] ++ modules;
        specialArgs = {
          inherit inputs outputs;
          pkgs-unstable = pkgsFor.nixpkgs-unstable.${system};
        } // specialArgs;
      };

      homeConfig = { modules, system, specialArgs ? { } }: lib.homeManagerConfiguration {
        pkgs = pkgsFor.nixpkgs.${system};
        modules = [ ./modules/home-manager ] ++ modules;
        extraSpecialArgs = {
          inherit inputs outputs;
          pkgs-unstable = pkgsFor.nixpkgs-unstable.${system};
        } // specialArgs;
      };
    in
    {
      overlays = import ./overlays { inherit inputs outputs; };
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });

      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      templates = import ./templates;

      # FIXME: what is this
      # nixosModules = import ./modules/nixos { inherit inputs outputs; };
      # homeManagerModules = forEachSystem (pkgs: import ./modules/home-manager { inherit pkgs inputs outputs; });

      nixosConfigurations = {
        uicom = nixosConfig {
          modules = [ ./hosts/uicom ];
          system = "x86_64-linux";
        };

        vm-imper-test = nixosConfig {
          modules = [ ./hosts/vm-imper-test ];
          system = "x86_64-linux";
        };

        vm-imper-mini = nixosConfig {
          modules = [ ./hosts/vm-imper-mini ];
          system = "x86_64-linux";
        };
      };

      homeConfigurations = {
        "ui@uicom" = homeConfig {
          modules = [ ./users/ui/uicom ];
          system = "x86_64-linux";
        };
      };
    };
}
