{ pkgs, stdenv, ... }:

{
  nixpkgs = {
    overlays = [
      (self: super: {
        dwm = super.dwm.overrideAttrs (oldattrs: {
          src = ../../../pkgs/dwm;
        });
      })
    ];
  };

  environment.systemPackages = with pkgs; [
    (callPackage ../../../pkgs/dwmblocks { })
  ];

  services.xserver = {
    enable = true;
    windowManager.dwm.enable = true;
    # displayManager.setupCommands = ''
    #   dwmblocks &
    # '';
  };
}
