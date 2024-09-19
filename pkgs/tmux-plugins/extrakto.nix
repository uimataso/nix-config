{ lib
, fetchFromGitHub
, pkgs
,
}:
pkgs.tmuxPlugins.mkTmuxPlugin {
  pluginName = "extrakto";
  version = "unstable-2024-08-26";
  src = fetchFromGitHub {
    owner = "laktak";
    repo = "extrakto";
    rev = "bf9e666f2a6a8172ebe99fff61b574ba740cffc2";
    sha256 = "sha256-kIhJKgo1BDTeFyAPa//f/TrhPfV9Rfk9y4qMhIpCydk=";
  };
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  postInstall = ''
    for f in extrakto.py extrakto_plugin.py; do
      sed -i -e 's|#!/usr/bin/env python3|#!${pkgs.python3}/bin/python3|g' $target/$f
    done

    wrapProgram $target/scripts/open.sh \
      --prefix PATH : ${
        with pkgs;
        lib.makeBinPath [
          fzf
          xclip
          wl-clipboard
        ]
      }
  '';
  meta = {
    homepage = "https://github.com/laktak/extrakto";
    description = "Fuzzy find your text with fzf instead of selecting it by hand ";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ kidd ];
  };
}
