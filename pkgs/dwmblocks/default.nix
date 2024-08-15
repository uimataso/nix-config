{
  lib,
  stdenv,
  libX11,
}:
stdenv.mkDerivation rec {
  pname = "dwmblocks";
  version = "1.0";

  buildInputs = [libX11];
  makeFlags = ["PREFIX=$(out)"];

  src = ./.;
}
