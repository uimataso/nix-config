{ writeShellApplication
, pkgs
}: writeShellApplication {
  name = "rebuild";
  runtimeInputs = with pkgs; [

  ];

  text = ''
    set -e

    pushd ~/nix

    ${EDITOR} flake.nix

    alejandra . &>/dev/null
    git diff -U0 *.nix

    echo "NixOS Rebuilding..."

    doas nixos-rebuild switch --impure --flake /etc/nixos/#default &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)

    current=$(nixos-rebuild list-generations | grep current)
    git commit -am "$current"

    popd
    notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
  '';
}
