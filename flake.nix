{
  description = "My flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";

    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";

    arkenfox.url = "github:dwarfmaster/arkenfox-nixos";
    arkenfox.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      # systems = [ "x86_64-linux" ];
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      lib = nixpkgs.lib // home-manager.lib;
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;

      nixosConfigurations = {
        vm = lib.nixosSystem {
          modules = [ ./hosts/vm ];
          specialArgs = { inherit inputs outputs; };
        };

        uicom = lib.nixosSystem {
          modules = [ ./hosts/uicom ];
          specialArgs = { inherit inputs outputs; };
        };
      };

      homeConfigurations = {
        "ui@vm" = lib.homeManagerConfiguration {
          modules = [ ./users/ui/vm.nix ];
          inherit pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
        };

        "ui@uicom" = lib.homeManagerConfiguration {
          modules = [ ./users/ui/uicom.nix ];
          inherit pkgs;
          extraSpecialArgs = { inherit inputs outputs; };
        };
      };

    };
}
