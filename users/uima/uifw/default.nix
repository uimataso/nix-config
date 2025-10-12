{
  self,
  pkgs,
  ...
}:
{
  imports = [
    ./hyprland.nix
    ./waybar.nix
  ];

  home.username = "uima";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    qmk
    restic

    nsxiv
    mpv

    scripts.pdf-decrypt
    scripts.mkbigfile
    scripts.fetch-title

    xh
    gitui
    presenterm
    mermaid-cli
    bc
    hyperfine
    gimp
    drawing
  ];

  # services.mpd.enable = true;
  # programs.rmpc = {
  #   enable = true;
  #   config = "";
  # };

  stylix =
    let
      themePath = "${self}/modules/nixos/theme";
    in
    {
      image = "${themePath}/wallpapers/looking-for.png";
      base16Scheme = "${themePath}/gruvbox-dark-moded.yaml";
    };

  uimaConfig = {
    global.enable = true;

    system = {
      impermanence = {
        enable = true;
        directories = [
          "notes"
          "src"

          ".config/qmk"
        ];
      };

      inputMethod.fcitx5.enable = true;
      xdgUserDirs.enable = true;
    };

    sh = {
      bash.enable = true;
      bash.defaultShell = true;
    };

    desktop = {
      enable = true;
      type = "wayland";

      wayland = {
        dunst.enable = true;
      };

      monitors = [
        {
          name = "eDP-1";
          primary = true;
          width = 2880;
          height = 1920;
          refreshRate = 120;
          scale = 2.0;
        }
      ];
    };

    services = {
      pipewire.enable = true;
      udiskie.enable = true;
    };

    programs = {
      terminal = {
        alacritty.enable = true;
        # alacritty.defaultTerminal = true;
        foot.enable = true;
        foot.defaultTerminal = true;
      };

      editor = {
        neovim.enable = true;
        neovim.defaultEditor = true;
      };

      browser = {
        librewolf.enable = true;
        librewolf.defaultBrowser = true;
        brave.enable = true;
        vimiumOptions.enable = true;
      };

      dev = {
        ssh.enable = true;
        direnv.enable = true;
        git.enable = true;
        lazygit.enable = true;
        gh.enable = true;
        docker.enable = true;
        podman.enable = true;
        lazydocker.enable = true;
      };

      dmenu = {
        tofi.enable = true;
        tofi.defaultDmenu = true;
      };

      sh-util = {
        default = true;
        nix-helper.flakeDir = "/share/nix";

        aerc.enable = true;
        neomutt.enable = true;

        eza.enable = true;
        tmux.enable = true;
      };

      game = {
        osu.enable = true;
      };

      misc = {
        anki.enable = true;
        nixcord.enable = true;
        zathura.enable = true;

        # bitwarden.enable = true;
        # protonmail.enable = true;
        thunderbird.enable = true;

        prusaSlicer.enable = true;
        kicad.enable = true;
        freecad.enable = true;
        openscad.enable = true;
      };
    };
  };
}
