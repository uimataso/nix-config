{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    ;
  cfg = config.uimaConfig.programs.sh-util.nix-helper;

  flakeDir = config.uimaConfig.global.flakeDir;
in
{
  options.uimaConfig.programs.sh-util.nix-helper = {
    enable = mkEnableOption ''
      Yet-another-nix-helper and other nix alias/scripts that improve QoL.
    '';
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      no = "nh os switch ${flakeDir}";
      nu = "git -C ${flakeDir} pull && nh os switch ${flakeDir}";
      nt = "nh os test ${flakeDir}";
      nre = "nix repl --expr 'builtins.getFlake \"${flakeDir}\"'";
      nrr = "nixos-rebuild repl --flake ${flakeDir}";
      nd = "nix develop path:$(pwd)";

      it = "${pkgs.scripts.nix-template-tool}/bin/nix-template-tool";
    };

    programs.nh.enable = true;
  };
}
