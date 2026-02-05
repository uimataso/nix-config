{
  self,
  pkgs,
  pkgs-stable,
  inputs,
  ...
}:
{
  imports = [
    ./hyprland.nix
    ./waybar.nix
  ];

  home.username = "uima";

  home.stateVersion = "23.11";

  nixpkgs.overlays = [ inputs.rust-overlay.overlays.default ];

  home.packages = with pkgs; [
    qmk
    restic

    nsxiv
    pkgs-stable.mpv

    scripts.pdf-decrypt
    scripts.mkbigfile
    scripts.fetch-title
    scripts.open-git-remote
    scripts._0x0

    obsidian

    xh
    gitui
    presenterm
    mermaid-cli
    bc
    hyperfine
    bandwhich
    gimp
    drawing

    yt-dlp
    puddletag
    openssl

    gcc
    python3
    (rust-bin.stable.latest.default.override {
      extensions = [
        "rust-analyzer"
        "rust-std"
        "rust-src"
      ];
    })
  ];

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
    global.flakeDir = "/share/nix";

    system = {
      impermanence = {
        enable = true;
        directories = [
          "src"
          ".config/qmk"

          ".config/obsidian"
          ".config/puddletag"
          ".local/share/cargo"

          ".local/share/Steam"
          ".local/share/Terraria"
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
      mpd.enable = true;
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
        vimiumOptions.enable = true;
        qutebrowser.enable = true;
      };

      dev = {
        ssh.enable = true;
        direnv.enable = true;
        git = {
          enable = true;
          name = "uima";
          email = "git@uimataso.com";
        };
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

        eza.enable = true;
        tmux.enable = true;
        qrencode.enable = true;

        aerc.enable = true;
        neomutt.enable = true;
      };

      misc = {
        anki.enable = true;
        discord.enable = true;
        zathura.enable = true;

        rmpc.enable = true;

        thunderbird.enable = true;

        # prusaSlicer.enable = true;
        # kicad.enable = true;
        # freecad.enable = true;
        # openscad.enable = true;
      };
    };
  };
}
