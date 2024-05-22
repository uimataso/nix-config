{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.system.input-method;
in
{
  options.uimaConfig.system.input-method = {
    enable = mkEnableOption "input-method";
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [ fcitx5-rime ];
    };

    # ref:
    # - https://github.com/search?q=nix+fcitx5&type=code
    # - https://github.com/ryan4yin/nix-config/blob/82dccbdecaf73835153a6470c1792d397d2881fa/home/linux/gui/base/fcitx5/default.nix
    # - https://github.com/ryan4yin/nix-config/blob/82dccbdecaf73835153a6470c1792d397d2881fa/overlays/fcitx5/README.md
    xdg.configFile = {
      "fcitx5/config".source = ./fcitx5-config;
      "fcitx5/conf/classicui.conf".source = ./fcitx5-conf-classicui.conf;
      "fcitx5/profile" = {
        source = ./fcitx5-profile;
        force = true;
      };
    };
  };
}
