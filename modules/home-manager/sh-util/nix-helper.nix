{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.sh-util.nix-helper;

  homeDir = config.home.homeDirectory;
  configHome = config.xdg.configHome;
in
{
  options.uimaConfig.sh-util.nix-helper = {
    enable = mkEnableOption ''
      Yet-another-nix-helper and other nix alias/sceripts that improve QoL.
    '';

    flakeDir = mkOption {
      type = types.str;
      default = "${homeDir}/nix";
      description = "Root of your flake directory";
    };
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      no = "nh os switch ${cfg.flakeDir}";
      nt = "nh os test ${cfg.flakeDir}";
      nr = "nix repl --expr 'builtins.getFlake \"${cfg.flakeDir}\"'";

      it = "${pkgs.scripts.nix-template-tool}/bin/nix-template-tool";

      nvim-test = ''
        rm -f ${configHome}/nvim && ln -s ${cfg.flakeDir}/modules/home-manager/programs/neovim ${configHome}/nvim
      '';
      nvim-clean = "rm ${configHome}/nvim";
    };

    home.packages = with pkgs; [ nh ];
  };
}
