{ config
, lib
, pkgs
, inputs
, outputs
, ...
}:
let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.uimaConfig.global;
in
{
  options.uimaConfig.global = {
    enable = mkEnableOption "Global settings";
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

    uimaConfig.theme.enable = mkDefault true;
    uimaConfig.programs.sh-util.nix-helper.enable = mkDefault true;
  };
}
