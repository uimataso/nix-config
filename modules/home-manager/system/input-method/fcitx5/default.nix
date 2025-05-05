{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.system.inputMethod.fcitx5;
in
{
  options.uimaConfig.system.inputMethod.fcitx5 = {
    enable = mkEnableOption "input-method fcitx5";
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";

      fcitx5.addons = with pkgs; [
        fcitx5-rime
        fcitx5-mozc
      ];
    };

    home.sessionVariables = {
      "INPUT_METHOD" = "fcitx";
      # "GTK_IM_MODULE" = "fcitx";
      "QT_IM_MODULE" = "fcitx";
      "XMODIFIERS" = "@im=fcitx";
      # "GLFW_IM_MODULE" = "ibus";
      # "SDL_IM_MODULE" = "fcitx";
    };

    # https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland
    gtk.gtk2.extraConfig = ''
      gtk-im-module="fcitx"
    '';
    gtk.gtk3.extraConfig = {
      gtk-im-module = "fcitx";
    };
    gtk.gtk4.extraConfig = {
      gtk-im-module = "fcitx";
    };

    # FIXME: theme is different on firefox and other apps
    i18n.inputMethod.fcitx5.settings = {
      globalOptions = {
        Behavior = {
          ActiveByDefault = false;
          resetStateWhenFocusIn = "No";
          ShareInputState = "All";
        };

        Hotkey = {
          EnumerateWithTriggerKeys = true;
          EnumerateSkipFirst = false;
          ModifierOnlyKeyTimeout = 250;
        };

        "Hotkey/TriggerKeys"."0" = "Control+Alt+Shift+I";
        "Hotkey/TriggerKeys"."1" = "Super+I";
        "Hotkey/PrevPage"."0" = "Up";
        "Hotkey/NextPage"."0" = "Down";
        "Hotkey/PrevCandidate"."0" = "Shift+Tab";
        "Hotkey/NextCandidate"."0" = "Tab";
        "Hotkey/TogglePreedit"."0" = "Control+Alt+P";
      };

      inputMethod = {
        GroupOrder."0" = "Default";

        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "rime";
        };
        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = "rime";
        "Groups/0/Items/2".Name = "mozc";
      };

      addons = {
      };
    };

    # Rime
    home.file.".local/share/fcitx5/rime" = {
      source = ../rime/yuhao-schema;
      recursive = true;
    };

    home.file.".local/share/fcitx5/rime/default.custom.yaml" = {
      source = ../rime/default.custom.yaml;
    };
  };
}
