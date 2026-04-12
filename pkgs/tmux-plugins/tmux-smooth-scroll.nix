{
  fetchFromGitHub,
  pkgs,
}:
pkgs.tmuxPlugins.mkTmuxPlugin {
  pluginName = "tmux-smooth-scroll";
  version = "unstable-2026-03-05";
  rtpFilePath = "smooth-scroll.tmux";
  src = fetchFromGitHub {
    owner = "azorng";
    repo = "tmux-smooth-scroll";
    rev = "e7f0b489d28f85e5a4e90d1aae335ac390159657";
    sha256 = "sha256-2oDwVMuuu6gnaKqaqUjTdJ4nMuvOIt04W5SipxHBxQY=";
  };
}
