{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkForce
    types
    ;
  cfg = config.uimaConfig.sh.nushell;
in
{
  options.uimaConfig.sh.nushell = {
    enable = mkEnableOption "nushell";

    aliases = lib.mkOption {
      type = types.attrsOf types.str;
      default = { };
    };
  };

  config = mkIf cfg.enable {
    programs.nushell = {
      enable = true;

      settings = {
        show_banner = false;
        buffer_editor = "nvim";
        # table.mode = "frameless"; # also nice: light, markdown
      };

      envFile.text = /* nu */ ''
        $env.PROMPT_COMMAND_RIGHT = ""
      '';

      shellAliases = mkForce (
        cfg.aliases
        // {
          c = "cd";
          c- = "cd -";
          "c." = "cd ..";
          "c.." = "cd ../..";
          "c..." = "cd ../../..";
          "c...." = "cd ../../../..";
          "c....." = "cd ../../../../..";

          e = "^$env.EDITOR";
          "e." = "^$env.EDITOR .";

          l = "ls";
          ls = "ls -a";
          ll = "ls -al";
        }
      );
    };
  };
}
