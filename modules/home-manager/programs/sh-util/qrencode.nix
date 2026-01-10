{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.sh-util.aerc;
in
{
  options.uimaConfig.programs.sh-util.qrencode = {
    enable = mkEnableOption "qrencode";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      qrencode
    ];

    home.shellAliases = {
      qr = "qrencode -s8 -m2 -t UTF8";
      qri = "qrencode -s8 -m2 -t PNG -o -";
    };
  };
}
