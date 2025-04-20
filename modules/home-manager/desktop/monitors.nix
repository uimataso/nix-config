# Borrowed from: https://github.com/Misterio77/nix-config/blob/main/modules/home-manager/monitors.nix
{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.uimaConfig.desktop.monitors;
in
{
  options.uimaConfig.desktop.monitors = mkOption {
    type = types.listOf (
      types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            example = "DP-1";
          };
          primary = mkOption {
            type = types.bool;
            default = false;
          };

          width = mkOption {
            type = types.int;
            default = 1920;
          };
          height = mkOption {
            type = types.int;
            default = 1080;
          };
          refreshRate = mkOption {
            type = types.int;
            default = 60;
          };
          scale = mkOption {
            type = types.float;
            default = 1.0;
          };

          position = mkOption {
            type = types.str;
            default = "auto";
          };
          enabled = mkOption {
            type = types.bool;
            default = true;
          };
          workspace = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
        };
      }
    );
    default = [ ];
  };

  config = {
    assertions = [
      {
        assertion =
          let
            numMonitors = lib.length cfg;
            numPrimary = lib.length (lib.filter (m: m.primary) cfg);
          in
          (numMonitors != 0) -> (numPrimary == 1);
        message = "Exactly one monitor must be set to primary.";
      }
    ];
  };
}
