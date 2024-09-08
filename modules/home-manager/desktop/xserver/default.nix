{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.desktop.xserver;
in
{
  options.uimaConfig.desktop.xserver = {
    enable = mkEnableOption "Xserver";
  };

  imports = [
    ./dwmblocks
    ./dunst.nix
    ./dwm.nix
  ];

  config = mkIf cfg.enable {
    xsession = {
      enable = true;
      profilePath = "${config.xdg.dataHome}/x11/xprofile";
      scriptPath = "${config.xdg.dataHome}/x11/xsession";

      initExtra =
        with pkgs; # sh
        ''
          # TODO: Better way to manage monitor, see wayland/river.nix
          ${xorg.xrandr}/bin/xrandr --output HDMI-1 --mode 1920x1080 --rate 144.00

          ${xcompmgr}/bin/xcompmgr -n &
          # No screen saver
          ${xorg.xset}/bin/xset s off -dpms
          ${xwallpaper}/bin/xwallpaper --zoom ${config.stylix.image}
        '';
    };

    # Hide mouse cursor
    services.unclutter.enable = true;

    home.packages = with pkgs; [
      xclip
    ];
  };
}
