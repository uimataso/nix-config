{ pkgs, ... }:

{
  services.xserver.displayManager.sddm = {
    enable = true;
    theme = "astronaut";

    settings = {
      X11.UserAuthFile = ".cache/Xauthority";
    };
  };

  environment.systemPackages = with pkgs; [
    (libsForQt5.callPackage ../../../pkgs/sddm-astronaut-theme { })
  ];

  services.xserver.displayManager.sessionCommands = ''
    [[ -f $XDG_DATA_HOME/x11/xprofile ]] && . $XDG_DATA_HOME/x11/xprofile
    [[ -f $XDG_DATA_HOME/x11/xsession ]] && . $XDG_DATA_HOME/x11/xsession
  '';
}
