{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkIf mkEnableOption mkOption mkForce types;
  cfg = config.uimaConfig.programs.editor.vscode;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.programs.editor.vscode = {
    enable = mkEnableOption "vscode";

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = "Use vscode as default editor";
    };
  };

  config = mkIf cfg.enable {
    # home.persistence.main = mkIf imper.enable {
    #   directories = [ ];
    # };

    uimaConfig.programs.editor = mkIf cfg.defaultEditor {
      enable = true;
      executable = "nvim";
    };

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      # TODO: xdg dir: `.vscode-oss`
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        esbenp.prettier-vscode
        pkgs.vscode-extensions."42crunch".vscode-openapi
        redhat.vscode-yaml
      ];

      userSettings = {
        "workbench.startupEditor" = "none";
        "update.showReleaseNotes" = false;
        "editor.formatOnSave" = true;
        "vim.foldfix" = true;
        "editor.lineNumbers" = "relative";
        "editor.fontSize" = mkForce 13;
      };
    };
  };
}
