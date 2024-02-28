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
    (callPackage ../../../pkgs/dwmblocks {})
  ];

  services.xserver = {
    enable = true;
    windowManager.dwm.enable = true;
    # displayManager.setupCommands = ''
    #   dwmblocks &
    # '';
  };
}

# {
#   nixpkgs = {
#     overlays = [
#       (self: super: {
#         dwm = super.dwm.overrideAttrs (oldattrs: {
#           src = pkgs.fetchFromGitHub {
#             owner = "luck07051";
#             repo = "dwm";
#             rev = "caf45180c0f1a2c21baf9c8445ef8c53b72c68e7";
#             # hash = pkgs.lib.fakeHash;
#             hash = "sha256-CKo+Z2IQ5gd7zQJmGWPv0WCzpRqLQsTg7TJCrCRNW5k=";
#           };
#           conf = ./config.h;
#         });
#       })
#     ];
#   };
#
#   services.xserver = {
#     enable = true;
#
#     windowManager.dwm = {
#       enable = true;
#       # package = (pkgs.dwm.override {
#       #   conf = ./config.h;
#       # });
#     };
#   };
# }
