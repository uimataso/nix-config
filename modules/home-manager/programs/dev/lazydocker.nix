{
  config,
  lib,
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
    programs.lazydocker = {
      enable = true;
      settings = {
        gui = {
          showBottomLine = false;
          expandFocusedSidePanel = true;
          containerStatusHealthStyle = "icon";
        };
      };
    };

    home.shellAliases = {
      lzd = "lazydocker";
    };
  };
}
