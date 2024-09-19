{ pkgs ? import <nixpkgs> { }
,
}:
{
  sddm-astronaut-theme = pkgs.libsForQt5.callPackage ./sddm-astronaut-theme { };
}
  // import ./scripts { inherit pkgs; }
