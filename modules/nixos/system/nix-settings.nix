{ config, lib, inputs, ... }:

with lib;

let
  cfg = config.myConfig.system.nix-settings;
in {
  options.myConfig.system.nix-settings = {
    enable = mkEnableOption "nix setting";
  };

  config = mkIf cfg.enable {
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      use-xdg-base-directories = true;
    };
  };
}
