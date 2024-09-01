{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.uimaConfig.programs.nixcord;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.nixcord = {
    enable = mkEnableOption "Nixcord";
  };

  imports = [ inputs.nixcord.homeManagerModules.nixcord ];

  config = mkIf cfg.enable {
    home.persistence.main = mkIf imper.enable { directories = [ ".config/discord" ]; };

    programs.nixcord = {
      enable = true;
      # quickCss = "some CSS";  # quickCSS file
      # config = {
      #   useQuickCss = true;   # use out quickCSS
      #   themeLinks = [        # or use an online theme
      #     "https://raw.githubusercontent.com/link/to/some/theme.css"
      #   ];
      #   frameless = true; # set some Vencord options
      #   plugins = {
      #     hideAttachments.enable = true;    # Enable a Vencord plugin
      #     ignoreActivities = {    # Enable a plugin and set some options
      #       enable = true;
      #       ignorePlaying = true;
      #       ignoreWatching = true;
      #       ignoredActivities = [ "someActivity" ];
      #     };
      #   };
      # };
      # extraConfig = {
      #   # Some extra JSON config here
      #   # ...
      # };
    };
  };
}
