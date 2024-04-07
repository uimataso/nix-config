{
  description = "My flake";

  # TODO: disco, impermanence, sops
  # TODO: theme, manage key, programs solution

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";

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

  outputs = { self, nixpkgs, home-manager, disko, impermanence, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;

      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });

      nixosConfig = { modules, pkgs, specialArgs ? {} }: lib.nixosSystem {
        inherit pkgs;
        modules = [
          ./modules/nixos
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
        ] ++ modules;
        specialArgs = { inherit inputs outputs; } // specialArgs;
      };

      homeConfig = { modules, pkgs, specialArgs ? {} }: lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./modules/home-manager
          impermanence.nixosModules.home-manager.impermanence
        ] ++ modules;
        extraSpecialArgs = { inherit inputs outputs; } // specialArgs;
      };
    in
    {
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });

      templates = import ./templates;

      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        uicom = nixosConfig {
          modules = [ ./hosts/uicom ];
          pkgs = pkgsFor.x86_64-linux;
        };

        vm-minimal = nixosConfig {
          modules = [ ./hosts/vm-minimal ];
          pkgs = pkgsFor.x86_64-linux;
        };

        vm-btrfs = nixosConfig {
          modules = [ ./hosts/vm-btrfs ];
          pkgs = pkgsFor.x86_64-linux;
        };

        vm-impermanence = nixosConfig {
          modules = [ ./hosts/vm-impermanence ];
          pkgs = pkgsFor.x86_64-linux;
        };
      };

      homeConfigurations = {
        "ui@uicom" = homeConfig {
          modules = [ ./users/ui/uicom ];
          pkgs = pkgsFor.x86_64-linux;
        };
      };

    };
}
