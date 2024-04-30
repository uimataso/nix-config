{ lib
, fetchFromGitHub
, pkgs
, stdenv
}:

pkgs.tmuxPlugins.mkTmuxPlugin {
  pluginName = "tmux.nvim";
  version = "unstable-2024-03-05";
  src = fetchFromGitHub {
    owner = "aserowy";
    repo = "tmux.nvim";
    rev = "63e9c5e054099dd30af306bd8ceaa2f1086e1b07";
    sha256 = "sha256-jLB323O9BdOZJL6NOy5Bl/mJOlYg33NLIGdDg7mk33o";
  };
}
