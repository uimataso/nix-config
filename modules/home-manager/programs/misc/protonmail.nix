{
  config,
  lib,
  pkgs-stable,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.misc.protonmail;
in
{
  options.uimaConfig.programs.misc.protonmail = {
    enable = mkEnableOption "Proton Mail";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/Proton Mail"
      ];
    };

    home.packages = with pkgs-stable; [
      protonmail-desktop
    ];
  };
}
