{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.uimaConfig.programs.unfree.notion;

  # https://discourse.nixos.org/t/overrideattributes-for-a-new-notion-version/50334/3
  notionPkg =
    {
      appimageTools,
      lib,
      fetchurl,
    }:
    let
      pname = "notion-app";
      version = "3.12.1-1";

      src = fetchurl {
        url = "https://github.com/sdkane/notion-repackaged/releases/download/v${version}/Notion-${version}.AppImage";
        sha256 = "sha256-WUKfYLmuRgdBRk+guGMyAy6PQnCopzOzj1E7IhVuXsA=";
      };

      appimageContents = appimageTools.extract { inherit pname version src; };
    in
    appimageTools.wrapType2 {
      inherit pname version src;

      extraInstallCommands = ''
        install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace 'Exec=AppRun' 'Exec=${pname}'
        mkdir -p $out/share/icons
        cp -r ${appimageContents}/usr/share/icons/hicolor/0x0/apps/notion-app.png $out/share/icons/notion-app.png
      '';

      meta = with lib; {
        description = "Notion Desktop builds for Windows, MacOS and Linux.";
        homepage = "https://github.com/sdkane/notion-repackaged";
        license = licenses.unfree;
        maintainers = with maintainers; [ skane ];
        platforms = [ "x86_64-linux" ];
        mainProgram = "notion-app";
      };
    };

in
{
  options.uimaConfig.programs.unfree.notion = {
    enable = mkEnableOption "Notion";
  };

  config = mkIf cfg.enable {
    uimaConfig.system.impermanence = {
      directories = [
        ".config/Notion"
        ".config/notion-app-enhanced"
      ];
    };

    home.packages = [
      (pkgs.callPackage notionPkg { })
    ];
  };
}
