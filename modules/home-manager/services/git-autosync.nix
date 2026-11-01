{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.services.gitAutosync;
  home = config.home.homeDirectory;
in
{
  options.uimaConfig.services.gitAutosync = {
    enable = mkEnableOption "git-autosync for the pkm repos";
  };

  imports = [
    inputs.pkm-tools.homeManagerModules.default
  ];

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        "notes"
      ];
    };

    services.git-autosync.repos = {
      notes.path = "${home}/notes";
    };
  };
}
