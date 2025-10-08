{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;

  cfg = config.uimaConfig.desktop;
in
{
  imports = [
    ./wayland
    ./xserver
    ./monitors.nix
  ];

  options.uimaConfig.desktop = {
    enable = mkEnableOption "Enable desktop";

    type = mkOption {
      type = types.enum [
        "x11"
        "wayland"
      ];
      example = "wayland";
      description = "Which protocol";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = mkIf (cfg.type == "wayland") {
      NIXOS_OZONE_WL = "1";
    };
  };
}
