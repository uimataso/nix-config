{ pkgs, ... }:
let
  # cal power
  pow =
    base: exp:
    let
      pow' =
        base: exp:
        if exp == 0 then
          1
        else if exp <= 1 then
          base
        else
          (pow' base (exp - 1)) * base;
    in
    pow' base exp;

  mkTag = tag: builtins.toString (pow 2 (tag - 1));
in
{
  # NOTE: try to hide the title bar
  gtk = {
    gtk4.extraConfig.gtk-dialogs-use-header = false;
    gtk3.extraConfig.gtk-dialogs-use-header = false;
  };
  stylix.targets.gtk.extraCss = ''
    headerbar.default-decoration {
      margin-bottom: 50px;
      margin-top: -100px;
    }
  '';

  home.packages = with pkgs; [
    scripts.power-menu
    scripts.app-launcher
    scripts.screenshot
    scripts.vl
    scripts.bright
  ];

  wayland.windowManager.river = {
    settings = {
      map = {
        normal = {
          # Spawn
          "Super Return" = "spawn $TERMINAL";
          "Super B" = "spawn $BROWSER";
          "Super O" = "spawn 'app-launcher'";
          "Super Escape" = "spawn power-menu";

          "None Print" = "spawn 'screenshot full'";
          "Shift Print" = "spawn 'screenshot cur'";
          "Control Print" = "spawn 'screenshot sel'";

          "None XF86AudioMute" = "spawn 'vl mute'";
          "None XF86AudioLowerVolume" = "spawn 'vl down 3'";
          "None XF86AudioRaiseVolume" = "spawn 'vl up 3'";
          "None XF86AudioPrev" = "spawn 'notify-send prev'";
          "None XF86AudioPlay" = "spawn 'notify-send play'";
          "None XF86AudioNext" = "spawn 'notify-send next'";
          "None XF86MonBrightnessDown" = "spawn 'notify-send bri down'";
          "None XF86MonBrightnessUp" = "spawn 'notify-send bri up'";
        };
      };

      rule-add = {
        "-app-id" = {
          # Make Firefox have border
          firefox = "ssd";
          librewolf = "ssd";
          "*Notion*" = "tags ${mkTag 7}";
          "*Slack*" = "tags ${mkTag 8}";
          "*discord*" = "tags ${mkTag 9}";
          "*vesktop*" = "tags ${mkTag 9}";
        };
      };

      input = {
        "pointer-2362-628-PIXA3854:00_093A:0274_Touchpad" = {
          tap = true;
          natural-scroll = true;
        };
      };
    };
  };
}
