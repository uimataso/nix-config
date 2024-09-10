{ ... }:
{
  system.stateVersion = "23.11";

  networking.hostName = "araizen";
  time.timeZone = "Asia/Taipei";

  uimaConfig = {
    global.enable = true;

    users.uima.enable = true;

    system = {
      wsl.enable = true;
      sudo.enable = true;
      auto-upgrade.enable = true;
    };

    networking.networkmanager.enable = true;
    programs.bash.enable = true;
  };
}
