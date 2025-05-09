# TODO: make each tag has its own split width
{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkForce;

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
  home.packages = with pkgs; [
    xdg-desktop-portal-wlr
  ];

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
    enable = true;

    extraConfig = # sh
      ''
        # Fixing portal wlr: https://wiki.archlinux.org/title/River#Screencasting
        systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=river
        systemctl --user restart xdg-desktop-portal

        rivertile -view-padding 3 -outer-padding 3 &
      '';

    settings = with config.lib.stylix.colors; {
      default-layout = "rivertile";

      border-color-unfocused = mkForce "0x${base00}00";
      border-color-focused = mkForce "0x${base05}";
      border-width = 1;

      rule-add = {
        "-app-id" = {
          # Make Firefox have border
          firefox = "ssd";
          librewolf = "ssd";
          "*discord*" = "tags ${mkTag 9}";
          "*vesktop*" = "tags ${mkTag 9}";
        };
      };

      map-pointer = {
        normal = {
          # Super + Mouse Button to move/resize views or toggle float
          "super BTN_LEFT" = "move-view";
          "super BTN_RIGHT" = "resize-view";
          "super BTN_MIDDLE" = "toggle-float";
        };
      };

      map = {
        normal =
          {
            # Spawn
            "Super Return" = "spawn $TERMINAL";
            "Super B" = "spawn $BROWSER";
            "Super O" = "spawn 'app-launcher'";
            "Super Escape" = "spawn power-menu";

            # Super+Q to close window
            "Super Q" = "close";
            # Super+Space to bump the focused view to the top of the layout stack
            "Super Space" = "zoom";

            # Super+J and Super+K to focus the next/previous view in the layout stack
            "Super J" = "focus-view next";
            "Super K" = "focus-view previous";

            # Super+Shift+J and Super+Shift+K to swap the focused view with the next/previous
            # view in the layout stack
            "Super+Shift J" = "swap next";
            "Super+Shift K" = "swap previous";

            # Super+H and Super+L to decrease/increase the main ratio of rivertile(1)
            "Super H" = "send-layout-cmd rivertile \"main-ratio -0.05\"";
            "Super L" = "send-layout-cmd rivertile \"main-ratio +0.05\"";

            # Super+Shift+H and Super+Shift+L to increment/decrement the main count of rivertile(1)
            "Super+Shift H" = "send-layout-cmd rivertile \"main-count +1\"";
            "Super+Shift L" = "send-layout-cmd rivertile \"main-count -1\"";

            # Super+Alt+{H,J,K,L} to move views
            "Super+Alt H" = "move left 100";
            "Super+Alt J" = "move down 100";
            "Super+Alt K" = "move up 100";
            "Super+Alt L" = "move right 100";

            # Super+Alt+Control+{H,J,K,L} to snap views to screen edges
            "Super+Alt+Control H" = "snap left";
            "Super+Alt+Control J" = "snap down";
            "Super+Alt+Control K" = "snap up";
            "Super+Alt+Control L" = "snap right";

            # Super+Alt+Shift+{H,J,K,L} to resize views
            "Super+Alt+Shift H" = "resize horizontal -100";
            "Super+Alt+Shift J" = "resize vertical 100";
            "Super+Alt+Shift K" = "resize vertical -100";
            "Super+Alt+Shift L" = "resize horizontal 100";

            # Super+Period and Super+Comma to focus the next/previous output
            "Super Period" = "focus-output next";
            "Super Comma" = "focus-output previous";

            # Super+Shift+{Period,Comma} to send the focused view to the next/previous output
            "Super+Shift Period" = "send-to-output next";
            "Super+Shift Comma" = "send-to-output previous";

            # Super+{Up,Right,Down,Left} to change layout orientation
            "Super Up" = "send-layout-cmd rivertile \"main-location top\"";
            "Super Right" = "send-layout-cmd rivertile \"main-location right\"";
            "Super Down" = "send-layout-cmd rivertile \"main-location bottom\"";
            "Super Left" = "send-layout-cmd rivertile \"main-location left\"";
          }
          // (
            let
              tag_fn = key: tag: {
                "Super ${key}" = "set-focused-tags ${mkTag tag}";
                "Super+Shift ${key}" = "set-view-tags ${mkTag tag}";
                "Super+Control ${key}" = "toggle-focused-tags ${mkTag tag}";
                "Super+Shift+Control ${key}" = "toggle-view-tags ${mkTag tag}";
              };
            in
            (tag_fn "X" 1)
            // (tag_fn "C" 2)
            // (tag_fn "V" 3)
            // (tag_fn "S" 4)
            // (tag_fn "D" 5)
            // (tag_fn "F" 6)
            // (tag_fn "W" 7)
            // (tag_fn "E" 8)
            // (tag_fn "R" 9)

            // (tag_fn "1" 1)
            // (tag_fn "2" 2)
            // (tag_fn "3" 3)
            // (tag_fn "4" 4)
            // (tag_fn "5" 5)
            // (tag_fn "6" 6)
            // (tag_fn "7" 7)
            // (tag_fn "8" 8)
            // (tag_fn "9" 9)
          )
          // (
            let
              allTags = builtins.toString ((pow 2 32) - 1);
              allTagFn = key: {
                "Super ${key}" = "set-focused-tags ${allTags}";
                "Super+Shift ${key}" = "set-view-tags ${allTags}";
              };
            in
            (allTagFn "G") // (allTagFn "0")
          );
      };
    };
  };
}
