{ pkgs, ... }:

{
  users.users.ui = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.bashInteractive;
  };
}
