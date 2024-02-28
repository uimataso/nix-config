{ pkgs, ... }:

{
  environment.shells = [ pkgs.dash ];
  # Make /bin/sh -> /bin/dash
  environment.binsh = "${pkgs.dash}/bin/dash";
}
