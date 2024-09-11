{
  description = "uima's nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    # nixpkgs-local.url = "git+file:///home/uima/src/nixpkgs";

    systems.url = "github:nix-systems/default-linux";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    haumea.url = "github:nix-community/haumea/v0.2.2";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

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
    {
      self,
      nixpkgs,
      home-manager,
      systems,
      haumea,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;

      # Generate attrset for each system
      genAttrsForSystem = f: lib.genAttrs (import systems) f;

      # Nixpkgs for each system
      pkgsFor = genAttrsForSystem (
        system:
          import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          }
      );

      # Generate attrset for each system with Nixpkgs
      forEachSystem = f: genAttrsForSystem (system: f pkgsFor.${system});

      # Merge list of attrsets
      # Example:
      #   `mergeAttrsets [ { a = 1; b = 2; } { a = 3; c = 4; } ] -> { a = 3; b = 2; c = 4; }`
      # mergeAttrsets :: [set] -> set
      mergeAttrsets = list: lib.lists.foldl (acc: val: acc // val) { } list;

      # Merge sub attrsets
      # Example:
      #   `mergeSubAttrsets { x = { a = 1; b = 2; }; y = { a = 3; c = 4; }; } -> { a = 3; b = 2; c = 4; }`
      # mergeSubAttrsets :: set -> set
      mergeSubAttrsets = set: mergeAttrsets (lib.attrsets.attrValues set);

      # Map sub attrsets
      # Example:
      #   ```nix
      #   v = { x = { a = 1; b = 2; }; y = { a = 3; c = 4; }; }
      #   f = f = key: val: "${key}-${val}"
      #   nestMapAttrsets f v
      #   ```
      #   ```nix
      #   {
      #     x = { a = "x-a"; b = "x-b"; };
      #     y = { a = "y-a"; c = "y-c"; };
      #   }
      #   ```
      # mapSubAttrsets :: f -> set -> set
      # f :: key -> val -> any
      mapSubAttrsets = f: lib.attrsets.mapAttrs (key: vals: lib.attrsets.genAttrs (builtins.attrNames vals) (val: f key val));

      # Rename sub attrset's key
      # Example:
      #   ```nix
      #   v = { x = { a = 1; b = 2; }; y = { a = 3; c = 4; }; }
      #   f = f = key: val: "${key}-${val}"
      #   f = key: sub_key: sub_val: "${key}-${sub_key}-${builtins.toString sub_val}"
      #   renameSubAttrsetsKey f v
      #   ```
      #   ```nix
      #   {
      #     x = { x-a-1 = 1; x-b-2 = 2; };
      #     y = { y-a-3 = 3; y-c-4 = 4; };
      #   }
      #   ```
      # renameSubAttrsetsKey :: f -> set -> set
      # f :: key -> sub_key -> sub_val -> str
      renameSubAttrsetsKey = f: lib.attrsets.mapAttrs (
        key: val: lib.attrsets.mapAttrs' (sub_key: sub_val: lib.attrsets.nameValuePair (f key sub_key sub_val) sub_val) val
      );

      # Read hosts from `./hosts`
      #   Output: { host = "system type"; }
      hosts =
        let
          hosts = haumea.lib.load {
            src = ./hosts;
            loader = haumea.lib.loaders.path;
          };
          hosts' = mergeSubAttrsets (mapSubAttrsets (system: _: system) hosts);
        in
        hosts';

      # Read users from `./users`
      #   Output: { "user@host" = { user = "user"; host = "host" }; }
      users =
        let
          users = haumea.lib.load {
            src = ./users;
            loader = haumea.lib.loaders.path;
          };
          users' = mapSubAttrsets (user: host: { inherit user host; }) users;
          users'' = renameSubAttrsetsKey (user: host: val: "${user}@${host}") users';
          users''' = mergeSubAttrsets users'';
        in
        users''';

      # SpecialArgs that share between nixosConfig and homeConfig
      specialArgs = let
        inputPkgsFor = pkgs: genAttrsForSystem (
          system:
            import inputs.${pkgs} {
              inherit system;
              config.allowUnfree = true;
            }
        );
      in genAttrsForSystem (system: {
        inherit inputs outputs;
        pkgs-stable = inputPkgsFor.${system} "nixpkgs-stable";
        # pkgs-local = inputPkgsFor.${system} "nixpkgs-local";
      });

      # Given host name and system type, returning Nixos System
      # nixosConfig :: host name -> system type -> nixosSystem
      nixosConfig =
        host: system:
        lib.nixosSystem {
          pkgs = pkgsFor.${system};
          specialArgs = specialArgs.${system};

          modules = [
            # NixOS
            outputs.nixosModules
            ./hosts/${system}/${host}
            # Home Manager
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                sharedModules = [ outputs.homeManagerModules ];
                extraSpecialArgs = specialArgs.${system};
              };
            }
          ];
        };

      # Given user name and host name, returning Home Manager Configuration
      # homeConfig :: user name -> host name -> homeManagerConfiguration
      homeConfig =
        user: host:
        let
          system = hosts.${host};
        in
        lib.homeManagerConfiguration {
          pkgs = pkgsFor.${system};
          extraSpecialArgs = specialArgs.${system};
          modules = [
            outputs.homeManagerModules
            ./users/${user}/${host}
          ];
        };

      nixosConfigurations = lib.attrsets.mapAttrs nixosConfig hosts;
      homeConfigurations = lib.attrsets.mapAttrs (key: val: homeConfig val.user val.host) users;
    in
    {
      inherit lib;
      inherit nixosConfigurations;
      inherit homeConfigurations;

      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;

      overlays = import ./overlays { inherit inputs outputs; };
      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });

      formatter = forEachSystem (pkgs: pkgs.nixfmt-rfc-style);
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      templates = import ./templates;

      # FIXME: Github CI: nix eval always stack overflow
      # [](https://github.com/ryan4yin/nix-config/blob/main/.github/workflows/flake_evaltests.yml)
      # evalTests."araizen" = nixosConfigurations."araizen".config.system.build.toplevel;
    };
}
