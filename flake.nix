{
  description = "My flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    # nur.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";

    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
    arkenfox.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;

      systems = [ "x86_64-linux" "aarch64-linux" ];
      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
    in
    {
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });

      templates = import ./templates;

      nixosConfigurations = {
        vm = lib.nixosSystem {
          modules = [ ./hosts/vm ];
          pkgs = pkgsFor.x86_64-linux;
          specialArgs = { inherit inputs outputs; };
        };

        uicom = lib.nixosSystem {
          modules = [ ./hosts/uicom ];
          pkgs = pkgsFor.x86_64-linux;
          specialArgs = { inherit inputs outputs; };
        };
      };

      homeConfigurations = {
        "ui@vm" = lib.homeManagerConfiguration {
          modules = [ ./modules/home-manager ./users/ui/vm ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };

        "ui@uicom" = lib.homeManagerConfiguration {
          modules = [ ./modules/home-manager ./users/ui/uicom ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };

    };
}
