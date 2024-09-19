{ stdenv
, fetchFromGitHub
, qtgraphicaleffects
, qtmultimedia
,
}:
stdenv.mkDerivation {
  pname = "sddm-astronaut-theme";
  version = "1.0";
  dontBuild = true;
  dontWrapQtApps = true;

  propagatedUserEnvPkgs = [
    qtgraphicaleffects
    qtmultimedia
  ];

  postInstall = ''
    mkdir -p $out/share/sddm/themes/astronaut
    mv * $out/share/sddm/themes/astronaut/
  '';

  src = fetchFromGitHub {
    owner = "Keyitdev";
    repo = "sddm-astronaut-theme";
    rev = "468a100460d5feaa701c2215c737b55789cba0fc";
    sha256 = "sha256-L+5xoyjX3/nqjWtMRlHR/QfAXtnICyGzxesSZexZQMA=";
  };
}
