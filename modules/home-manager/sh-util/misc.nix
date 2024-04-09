{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.myConfig.sh-util.misc;
in
{
  options.myConfig.sh-util.misc = {
    enable = mkEnableOption "misc";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fd
      ripgrep
      htop
      bat
      rsync
      jq
    ];

    home.shellAliases = {
      rc = "rsync -vhP";
      fclist = "fc-list : family";

      ipinfo = "curl ipinfo.ip";
      unitest = "curl https://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-demo.txt";
    };
  };
}
