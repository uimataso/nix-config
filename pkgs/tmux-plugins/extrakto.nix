{ lib
, fetchFromGitHub
, pkgs
, stdenv
}:

pkgs.tmuxPlugins.mkTmuxPlugin {
  pluginName = "extrakto";
  version = "unstable-2024-04-25";
  src = fetchFromGitHub {
    owner = "laktak";
    repo = "extrakto";
    rev = "e9e3184aca6ed1068743db8cba4face8b1222ad5";
    sha256 = "sha256-svrC/GDwbeYPRmxRWjvQUPC8ZxXvC95GXqvrCBqiwLU";
  };
  nativeBuildInputs = with pkgs; [ makeWrapper ];
  postInstall = ''
    for f in extrakto.sh open.sh; do
      wrapProgram $target/scripts/$f \
        --prefix PATH : ${with pkgs; lib.makeBinPath [ fzf python3 xclip ]}
    done
  '';
  meta = {
    homepage = "https://github.com/laktak/extrakto";
    description = "Fuzzy find your text with fzf instead of selecting it by hand ";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ kidd ];
  };
}
