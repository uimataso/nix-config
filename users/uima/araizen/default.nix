{ config, pkgs, lib, inputs, ... }:

{
  home.username = "uima";

  home.stateVersion = "23.11";

  # home.persistence.main = {
  #   directories = [
  #     "nix"
  #     "src"
  #   ];
  # };

  home.packages = with pkgs; [
    fd
    scripts.extract
  ];

  # Options without setting
  programs.htop.enable = true;
  programs.btop.enable = true;
  programs.ripgrep.enable = true;
  programs.jq.enable = true;
  programs.bat.enable = true;

  uimaConfig = {
    global.enable = true;

    theme.wallpaper = ./wallpaper.png;

    system = {
      # impermanence.enable = true;
      # input-method.fcitx5.enable = true;
      xdg.enable = true;
      xdg-user-dirs.enable = true;
    };

    sh = {
      bash.enable = true;
      # bash.defaultShell = true;
      nushell.enable = true;
      nushell.defaultShell = true;
    };

    sh-util = {
      fzf.enable = true;
      fff.enable = true;
      eza.enable = true;
      tmux.enable = true;
      tmuxinator.enable = true;
      tealdeer.enable = true;
    };

    dev = {
      direnv.enable = true;
      git = {
        enable = true;
        name = "Uima";
        email = "uima.chen@araizen.com";
      };
      lazygit.enable = true;
    };

    programs = {
      neovim.enable = true;
      neovim.defaultEditor = true;

      ssh.enable = true;
    };
  };

  programs.ssh.extraConfig = ''
    Host github
      HostName github.com
      IdentityFile ~/.ssh/id_ed25519_uima_chen
      IdentitiesOnly yes

    Host github-personal
      HostName github.com
      IdentityFile ~/.ssh/id_ed25519
      IdentitiesOnly yes
  '';
}
