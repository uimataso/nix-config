{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.dev.k8s;
in
{
  options.uimaConfig.dev.k8s = {
    enable = mkEnableOption "k8s";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kubectl
    ];

    home.shellAliases = {
      ku = "kubectl";
    };
  };
}
