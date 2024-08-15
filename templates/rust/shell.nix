{
  callPackage,
  rust-analyzer,
  rustfmt,
  clippy,
  cargo-nextest,
}: let
  mainPkg = callPackage ./default.nix {};
in
  mainPkg.overrideAttrs (oa: {
    nativeBuildInputs =
      [
        # Additional rust tooling
        rust-analyzer
        rustfmt
        clippy
        cargo-nextest
      ]
      ++ (oa.nativeBuildInputs or []);
  })
