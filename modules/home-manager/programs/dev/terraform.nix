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
    # uimaConfig.system.impermanence = {
    #   directories = [
    #   ];
    # };

    home.packages = with pkgs; [
      terraform
    ];

    home.shellAliases = {
      tf = "terraform";
    };
  };
}
