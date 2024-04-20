{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.uimaConfig.sh-util.misc;
in
{
  options.uimaConfig.sh-util.misc = {
    enable = mkEnableOption "misc";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fd
      rsync
    ];

    programs.htop.enable = true;
    programs.jq.enable = true;
    programs.ripgrep.enable = true;

    home.shellAliases = {
      rc = "rsync -vhP";
      fclist = "fc-list : family";

      unitest = "curl https://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-demo.txt";
    };
  };
}
