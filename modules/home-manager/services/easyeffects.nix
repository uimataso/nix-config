{ config, lib, ... }:
with lib;
let
  cfg = config.uimaConfig.services.easyeffects;
  settings = config.services.easyeffects;

  imper = config.uimaConfig.system.impermanence;
in
{
  options.uimaConfig.services.easyeffects = {
    enable = mkEnableOption "Easyeffects";
  };

  config = mkIf cfg.enable {
    services.easyeffects = {
      enable = true;
      preset = "masc_voice_noise_reduction";
    };

    xdg.configFile = {
      # Use [this](https://gist.github.com/jtrv/47542c8be6345951802eebcf9dc7da31) input preset. Change this values:
      #   "rnnoise#0": {
      #       "enable-vad": true,
      #       "output-gain": 20.0,
      #   },
      "easyeffects/input/${settings.preset}.json".source = ./${settings.preset}.json;
    };

    # TODO: upstream this?
    # Original command has --load-preset and --gapplication-service in one line,
    # and that whill make --load-preset has not effect in my test.
    systemd.user.services.easyeffects.Service = {
      ExecStartPre = "${settings.package}/bin/easyeffects --load-preset ${settings.preset}";
      ExecStart = mkForce "${settings.package}/bin/easyeffects --gapplication-service";
    };
  };
}
