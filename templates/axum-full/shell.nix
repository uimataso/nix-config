{
  callPackage,
  rust-analyzer,
  rustfmt,
  clippy,
  cargo-nextest,
  sqlx-cli,
}:
let
  mainPkg = callPackage ./default.nix { };
in
mainPkg.overrideAttrs (oa: {
  nativeBuildInputs = [
    # Additional rust tooling
    rust-analyzer
    rustfmt
    clippy
    cargo-nextest
    sqlx-cli
  ] ++ (oa.nativeBuildInputs or [ ]);
})
