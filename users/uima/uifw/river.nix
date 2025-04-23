{ ... }:
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

  wayland.windowManager.river = {
    settings = {
      map = {
        normal = {
          # Spawn
          "Super Return" = "spawn $TERMINAL";
          "Super B" = "spawn $BROWSER";
          "Super O" = "spawn 'app-launcher'";
          "Super Escape" = "spawn power-menu";
        };
      };

      rule-add = {
        "-app-id" = {
          # Make Firefox have border
          firefox = "ssd";
          librewolf = "ssd";
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
