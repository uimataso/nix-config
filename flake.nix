{
  description = "My flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    inherit (self) outputs;
    systems = [ "x86_64-linux" ];
    lib = nixpkgs.lib // home-manager.lib;
  in {

    nixosConfigurations = {
      vm = lib.nixosSystem {
        modules = [ ./hosts/vm ];
        specialArgs = { inherit inputs outputs; };
      };
    };

    homeConfigurations = {
      "ui@vm" = lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [ ./users/ui/vm.nix ];
        extraSpecialArgs = { inherit inputs outputs; };
      };
    };

  };
}
