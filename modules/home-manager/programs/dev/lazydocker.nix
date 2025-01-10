{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.dev.lazydocker;
in
{
  options.uimaConfig.programs.dev.lazydocker = {
    enable = mkEnableOption "Lazydocker";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lazydocker
    ];

    home.shellAliases = {
      lzd = "lazydocker";
    };
  };
}
