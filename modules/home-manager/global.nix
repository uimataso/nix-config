{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    mkDefault
    types
    ;
  cfg = config.uimaConfig.global;
in
{
  options.uimaConfig.global = {
    enable = mkEnableOption "Global settings";

    flakeDir = mkOption {
      type = types.str;
      description = "Root of your flake directory";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.nur.overlays.default ] ++ builtins.attrValues outputs.overlays;

    home.homeDirectory = mkDefault "/home/${config.home.username}";

    nixpkgs.config.allowUnfree = true;

    nix.package = mkDefault pkgs.nix;

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };

    news.display = "silent";

    uimaConfig.programs.sh-util.nix-helper.enable = mkDefault true;
    uimaConfig.system.xdg.enable = mkDefault true;

    uimaConfig.system.impermanence.directories = [
      # Otherwise the cache file will be owned by root
      ".cache/nix"
    ];

    home.sessionVariables = {
      FLAKE_HOME = cfg.flakeDir;
    };
  };
}
