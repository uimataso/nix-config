{ pkgs }:

{
  default = pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      nix
      home-manager
      git
    ];
  };
}
