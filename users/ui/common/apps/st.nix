{ pkgs, ... }:

{
  nixpkgs = {
    overlays = [
      (self: super: {
        st = super.st.overrideAttrs (oldattrs: {
          src = pkgs.fetchFromGitHub {
            owner = "luck07051";
            repo = "st";
            rev = "425c8b848bafa6a02afef302cd1e59890c0de9e2";
            hash = "sha256-a1n5bhiczYaS59zuUbD4CN87COZ3be9Cnzcg4ktQ+ng=";
          };
        });
      })
    ];
  };

  home.packages = [ pkgs.st ];

  home.sessionVariables = {
    TERMINAL = "st";
  };
}
