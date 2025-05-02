{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.dev.k8s;
in
{
  options.uimaConfig.programs.dev.k8s = {
    enable = mkEnableOption "k8s";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/kube"
      ];
    };

    home.packages = with pkgs; [
      kubectl
    ];

    home.sessionVariables = {
      KUBECONFIG = "${config.xdg.configHome}/kube/config";
      KUBECACHEDIR = "${config.xdg.cacheHome}/kube";
    };

    home.shellAliases = {
      k = "kubectl";
    };
  };
}
