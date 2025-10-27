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

  home.username = "araizen";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    lm_sensors

    nsxiv
    mpv

    argocd

    scripts.pdf-decrypt
    scripts.fetch-title
    scripts.notify-send-all

    xh
    gitui
    presenterm
    mermaid-cli
    bc
    hyperfine
    drawing
  ];

  programs.git.settings = {
    safe.directory = "/share/nix";
  };

  stylix =
    let
      themePath = "${self}/modules/nixos/theme";
    in
    {
      image = "${themePath}/wallpapers/coding-3.png";
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
        git = {
          enable = true;
          name = "uima-chen";
          email = "uima.chen@araizen.com";
        };
        lazygit.enable = true;
        gh.enable = true;
        docker.enable = true;
        lazydocker.enable = true;
        aws-cli.enable = true;
        k8s.enable = true;
        terraform.enable = true;
      };

      dmenu = {
        tofi.enable = true;
        tofi.defaultDmenu = true;
      };

      sh-util = {
        default = true;
        nix-helper.flakeDir = "/share/nix";

        eza.enable = true;
        tmux.enable = true;
      };

      unfree = {
        postman.enable = true;
        slack.enable = true;
      };

      misc = {
        zathura.enable = true;
        thunderbird.enable = true;
      };
    };
  };
}
