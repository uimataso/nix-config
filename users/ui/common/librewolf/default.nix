{ ... }:

{
  programs.librewolf = {
    enable = true;
    settings = {
      # "webgl.disabled" = false;
      # "privacy.resistFingerprinting" = false;
    };
  };

  home.file.".librewolf/chrome".source = ./chrome;

  home.sessionVariables = {
    BROWSER = "librewolf";
  };
}
