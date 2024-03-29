{ config, lib, ... }:

# Need hosts/udisks2 to work

with lib;

let
  cfg = config.myConfig.services.udiskie;
in {
  options.myConfig.services.udiskie = {
    enable = mkEnableOption "udiskie";
  };

  config = mkIf cfg.enable {
    services.udiskie.enable = true;
  };
}
