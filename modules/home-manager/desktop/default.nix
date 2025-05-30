{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
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
}
