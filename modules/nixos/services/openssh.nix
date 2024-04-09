{ config, lib, ... }:

with lib;

let
  cfg = config.myConfig.services.openssh;
in {
  options.myConfig.services.openssh = {
    enable = mkEnableOption "openssh";
  };

  config = mkIf cfg.enable {
    services.openssh.enable = true;
  };
}
