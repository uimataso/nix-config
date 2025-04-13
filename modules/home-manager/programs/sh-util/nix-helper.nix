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
    mkOption
    types
    ;
  cfg = config.uimaConfig.programs.sh-util.nix-helper;

  homeDir = config.home.homeDirectory;
  configHome = config.xdg.configHome;
in
{
  options.uimaConfig.programs.sh-util.nix-helper = {
    enable = mkEnableOption ''
      Yet-another-nix-helper and other nix alias/scripts that improve QoL.
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
      nu = "git -C ${cfg.flakeDir} pull && nh os switch ${cfg.flakeDir}";
      nt = "nh os test ${cfg.flakeDir}";
      nr = "nix repl --expr 'builtins.getFlake \"${cfg.flakeDir}\"'";
      nd = "nix develop path:$(pwd)";

      it = "${pkgs.scripts.nix-template-tool}/bin/nix-template-tool";

      nvim-test = ''
        rm ${configHome}/nvim && ln -vs ${cfg.flakeDir}/modules/home-manager/programs/editor/neovim ${configHome}/nvim
      '';
      nvim-clean = "rm ${configHome}/nvim";
    };

    programs.nh.enable = true;
  };
}
