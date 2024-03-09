{ callPackage, python311Packages }:

let
  mainPkg = callPackage ./default.nix { };
in
mainPkg.overrideAttrs (oa: {
  nativeBuildInputs = [
    python311Packages.python-lsp-server
  ] ++ (oa.nativeBuildInputs or [ ]);
})
