# TODO: secrets
{ config, lib, ... }:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.dev.ssh;
in
{
  options.uimaConfig.programs.dev.ssh = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [ ".ssh" ];
    };

    programs.ssh = {
      enable = true;

      # since `enableDefaultConfig` is deprecated, I just copy pasted the following values
      enableDefaultConfig = false;
      matchBlocks."*" = {
        forwardAgent = false;
        addKeysToAgent = "no";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
    };
  };
}
