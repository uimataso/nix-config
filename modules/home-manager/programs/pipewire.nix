{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.programs.pipewire;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.pipewire = {
    enable = mkEnableOption "Settings and tool for pipewire";
  };

  config = mkIf cfg.enable {
    home.persistence.main = {
      directories = [
        ".local/state/wireplumber"
      ];
    };

    home.packages = with pkgs; [
      scripts.vl
    ];
  };
}
