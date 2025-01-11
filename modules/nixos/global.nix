{
  config,
  lib,
  pkgs,
  outputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption mkDefault;
  cfg = config.uimaConfig.global;
in
{
  options.uimaConfig.global = {
    enable = mkEnableOption "Global settings";
  };

  config = mkIf cfg.enable {
    nixpkgs = {
      overlays = builtins.attrValues outputs.overlays;
    };

    environment.systemPackages = with pkgs; [
      git # Since all nix command required Git
    ];

    nix = {
      # Disable channel since we use flakes
      channel.enable = false;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        warn-dirty = false;
      };
    };

    # Needed by home-manager and other
    programs.dconf.enable = true;

    # Make bash read `$XDG_CONFIG_HOME/bash/{profile, bashrc}`
    # Note, while running init, `$XDG_CONFIG_HOME` not available yet, so `$HOME/.config` is used instead of `$XDG_CONFIG_HOME`
    environment.shellInit = # sh
      ''
        if [[ -r "$HOME/.config/bash/profile" ]]; then . "$HOME/.config/bash/profile"; fi
      '';
    environment.interactiveShellInit = # sh
      ''
        if [[ -r "$HOME/.config/bash/bashrc" ]]; then . "$HOME/.config/bash/bashrc"; fi
      '';

    # Enable theme
    uimaConfig.theme.enable = true;
    # Enable ssh by default
    uimaConfig.system.openssh.enable = mkDefault true;
  };
}
