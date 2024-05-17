{ config, lib, ... }:

with lib;

let
  cfg = config.uimaConfig.sh.nushell;
in
{
  options.uimaConfig.sh.nushell = {
    enable = mkEnableOption "Bash";
  };

  config = mkIf cfg.enable rec {
    uimaConfig.sh.alias.enable = true;

    programs.nushell = {
      enable = true;
    };
  };
}
