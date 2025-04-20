{ ... }:
{
  # NOTE: try to hide the title bar
  gtk = {
    gtk4.extraConfig.gtk-dialogs-use-header = false;
    gtk3.extraConfig.gtk-dialogs-use-header = false;
  };
  stylix.targets.gtk.extraCss = ''
    headerbar.default-decoration {
      margin-bottom: 50px;
      margin-top: -100px;
    }
  '';

  wayland.windowManager.river = {
    settings = {
      map = {
        normal = {
          # Spawn
          "Super Return" = "spawn $TERMINAL";
          "Super B" = "spawn $BROWSER";
          "Super O" = "spawn 'app-launcher'";
          "Super Escape" = "spawn power-menu";
        };
      };
    };
  };
}
