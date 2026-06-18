{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.desktop.wayland.niri;

  # spawnCmd = ''"$TERMINAL" --app-id notes -e tmux new-session -A -s notes -c /share/notes $EDITOR inbox.md'';
  # spawnCmd = ''"$TERMINAL" --app-id scratchpad -e $EDITOR /share/scratchpad.md'';

  colors = config.lib.stylix.colors.withHashtag;
in
{
  options.uimaConfig.desktop.wayland.niri = {
    enable = mkEnableOption "niri";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      ni = "niri-session";
    };

    home.packages = with pkgs; [
      wl-clipboard
      brightnessctl
      playerctl

      scripts.power-menu
      scripts.app-launcher
    ];

    xdg.configFile."niri/config.kdl".text = /* kdl */ ''
      spawn-at-startup "noctalia-shell"

      screenshot-path "~/img/screenshots/screenshot_%Y-%m-%d_%H-%M-%S.png";

      prefer-no-csd

      hotkey-overlay {
        skip-at-startup
      }

      input {
        workspace-auto-back-and-forth

        keyboard {
          xkb {
            options "ctrl:nocaps"
          }
        }
      }

      layout {
        gaps 5

        always-center-single-column
        empty-workspace-above-first

        default-column-width { proportion 0.5; }
        preset-column-widths {
          proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        background-color "transparent"

        focus-ring { off; }
        border {
          on
          width 2
          active-color "${colors.base05}"
          inactive-color "${colors.base03}"
          urgent-color "${colors.base08}"
        }

        struts {
          left 32
          right 32
          top 8
          bottom 8
        }
      }

      animations {
        slowdown 0.5
      }

      layer-rule {
        match namespace="^awww-daemon$"
        place-within-backdrop true
      }

      window-rule {
        background-effect {
          blur true
        }
      }

      // workspace "notes" {
      //   layout {
      //     default-column-width { proportion 1.0; }
      //   }
      // }
      //
      // window-rule {
      //   match app-id="notes"
      //   open-on-workspace "notes"
      // }

      binds {
        Mod+Shift+Slash { show-hotkey-overlay; }

        Mod+Return hotkey-overlay-title="Open Terminal" { spawn "${config.uimaConfig.programs.terminal.executable}"; }
        Mod+B hotkey-overlay-title="Open Browser" { spawn "${config.uimaConfig.programs.browser.executable}"; }
        Mod+Shift+O hotkey-overlay-title="Open App Launcher" { spawn "app-launcher"; }
        Mod+Escape hotkey-overlay-title="Open Power Menu" { spawn "power-menu"; }

        Mod+Q repeat=false { close-window; }
        Mod+O repeat=false { toggle-overview; }

        Mod+Shift+E { quit; }

        // TODO: spawn notes app for first time call this
        // TODO: scratchpad
        // TODO: move workspace to focus monitor
        // TODO: when workspace only have one col, make it max widtth
        // Mod+N { focus-workspace "notes"; }

        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-or-workspace-down; }
        Mod+Up    { focus-window-or-workspace-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-or-workspace-down; }
        Mod+K     { focus-window-or-workspace-up; }
        Mod+L     { focus-column-right; }

        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Down  { move-window-down; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+H     { move-column-left; }
        Mod+Shift+J     { move-window-down; }
        Mod+Shift+K     { move-window-up; }
        Mod+Shift+L     { move-column-right; }

        Mod+Page_Down      { focus-workspace-down; }
        Mod+Page_Up        { focus-workspace-up; }
        Mod+U              { focus-workspace-down; }
        Mod+I              { focus-workspace-up; }
        Mod+Shift+Page_Down { move-column-to-workspace-down; }
        Mod+Shift+Page_Up   { move-column-to-workspace-up; }
        Mod+Shift+U         { move-column-to-workspace-down; }
        Mod+Shift+I         { move-column-to-workspace-up; }
        Mod+Shift+Ctrl+Page_Down { move-workspace-down; }
        Mod+Shift+Ctrl+Page_Up   { move-workspace-up; }
        Mod+Shift+Ctrl+U         { move-workspace-down; }
        Mod+Shift+Ctrl+I         { move-workspace-up; }

        Mod+Comma  { focus-monitor-previous; }
        Mod+Period { focus-monitor-next; }
        Mod+Shift+Comma  { move-workspace-to-monitor-previous; }
        Mod+Shift+Period { move-workspace-to-monitor-next; }
        Mod+Shift+Ctrl+Comma  { move-column-to-monitor-previous; }
        Mod+Shift+Ctrl+Period { move-column-to-monitor-next; }

        Mod+WheelScrollDown      cooldown-ms=150 { focus-workspace-down; }
        Mod+WheelScrollUp        cooldown-ms=150 { focus-workspace-up; }
        Mod+Ctrl+WheelScrollDown cooldown-ms=150 { move-column-to-workspace-down; }
        Mod+Ctrl+WheelScrollUp   cooldown-ms=150 { move-column-to-workspace-up; }

        Mod+WheelScrollRight      { focus-column-right; }
        Mod+WheelScrollLeft       { focus-column-left; }
        Mod+Ctrl+WheelScrollRight { move-column-right; }
        Mod+Ctrl+WheelScrollLeft  { move-column-left; }

        Mod+Shift+WheelScrollDown      { focus-column-right; }
        Mod+Shift+WheelScrollUp        { focus-column-left; }
        Mod+Ctrl+Shift+WheelScrollDown { move-column-right; }
        Mod+Ctrl+Shift+WheelScrollUp   { move-column-left; }

        Mod+A { toggle-window-floating; }

        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-column-width-back; }

        // Mod+Ctrl+Shift+R { switch-preset-window-height; }
        // Mod+Ctrl+R { reset-window-height; }

        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+Ctrl+F { expand-column-to-available-width; }

        Mod+M { maximize-window-to-edges; }
        Mod+Space { center-column; }
        Mod+Ctrl+Space { center-visible-columns; }

        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-"; }
        XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
        XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }

        XF86AudioPlay        allow-when-locked=true { spawn-sh "playerctl play-pause"; }
        XF86AudioStop        allow-when-locked=true { spawn-sh "playerctl stop"; }
        XF86AudioPrev        allow-when-locked=true { spawn-sh "playerctl previous"; }
        XF86AudioNext        allow-when-locked=true { spawn-sh "playerctl next"; }

        XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+3%"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "3%-"; }
      }
    '';
  };
}
