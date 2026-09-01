{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.dev.lazyjournal;
in
{
  options.uimaConfig.programs.dev.lazyjournal = {
    enable = mkEnableOption "lazyjournal";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      lzj = "lazyjournal";
    };

    home.packages = with pkgs; [
      lazyjournal
    ];
  };
}
