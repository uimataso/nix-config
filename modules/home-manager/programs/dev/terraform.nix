{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.dev.terraform;
in
{
  options.uimaConfig.programs.dev.terraform = {
    enable = mkEnableOption "TerraForm";
  };

  config = mkIf cfg.enable {
    # FIXME: with tflint config, tflint can install/read plugins properly
    # uimaConfig.system.impermanence = {
    #   # TODO: install plugin with `pkgs.tflint-plugins.tflint-ruleset-aws`
    #   directories = [
    #     ".cache/tflint/plugins"
    #   ];
    # };

    home.packages = with pkgs; [
      terraform
      terraform-local

      tflint
    ];

    # home.sessionVariables = {
    #   TFLINT_CONFIG_FILE = "${config.xdg.configHome}/tflint/config.hcl";
    # };
    #
    # xdg.configFile = {
    #   "tflint/config.hcl".text = # hcl
    #     ''
    #       config {
    #         plugin_dir = "${config.xdg.cacheHome}/tflint/plugins"
    #       }
    #     '';
    # };

    home.shellAliases = {
      tf = "terraform";
      tfl = "tflocal";
    };
  };
}
