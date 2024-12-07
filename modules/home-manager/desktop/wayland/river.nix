{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkIf mkEnableOption mkForce;
  cfg = config.uimaConfig.desktop.wayland.river;

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
  options.uimaConfig.desktop.wayland.river = {
    enable = mkEnableOption "river";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wl-clipboard
      wlr-randr
    ];

    # TODO: make each tag has its own split width

    wayland.windowManager.river = {
      enable = true;

      extraConfig = # sh
        ''
          rivertile -view-padding 3 -outer-padding 3 &

          # Set monitor
          # TODO: Better way to manage monitor
          # see: https://github.com/Misterio77/nix-config/blob/main/modules/home-manager/monitors.nix
          wlr-randr --output HDMI-A-1 --mode 1920x1080@144Hz
        '';

      settings = with config.stylix.base16Scheme; {
        default-layout = "rivertile";

        map = {
          normal =
            {
              "Super Q" = "close";

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

              # Super+Space to bump the focused view to the top of the layout stack
              "Super Space" = "zoom";

              # Spawn
              "Super Return" = "spawn $TERMINAL";
              "Super B" = "spawn $BROWSER";
              "Super O" = "spawn '$(tofi-run)'";
              "Super Escape" = "spawn power-menu";
            }
            // (
              let
                tag_fn =
                  key: tag:
                  {
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
            )
            // (
              let
                all_tags = builtins.toString ((pow 2 32) - 1);
              in
              {
                "Super G" = "set-focused-tags ${all_tags}";
                "Super+Shift G" = "set-view-tags ${all_tags}";
              }
            );
        };

        map-pointer = {
          normal = {
            # Super + Mouse Button to move/resize views or toggle float
            "super BTN_LEFT" = "move-view";
            "super BTN_RIGHT" = "resize-view";
            "super BTN_MIDDLE" = "toggle-float";
          };
        };

        rule-add = {
          "-app-id" = {
            # Make Firefox have border
            firefox = "ssd";
            "*discord*" = "tags ${mkTag 9}";
            "*vesktop*" = "tags ${mkTag 9}";
          };
        };

        border-color-unfocused = mkForce "0x${base00}00";
        border-color-focused = mkForce "0x${base0E}";
        border-color-urgent = mkForce "0x${base08}";
        border-width = 1;
      };
    };
  };
}
