{ rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "{{CODENAME}}";
  version = "0.1.1";

  src = ./.;
  cargoLock.lockFile = ./Cargo.lock;
}
