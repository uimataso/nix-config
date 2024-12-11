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
      autoUpgrade.enable = true;
    };
  };
}
