{ ... }:

{
  home.sessionVariables = {
    DIRENV_LOG_FORMAT = "";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    config.whitelist.prefix = [
      "~/src"
    ];

    config.whitelist.exact = [
      "~/nix"
    ];
  };
}
