{ inputs, config, ... }:

# How to install:
#
# $ sudo -i
# $ flake_url='github:uimataso/nix-config#uifw'
#
# $ vim /tmp/secret.key  # for luks password
# $ nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko -f "$flake_url"
# $ nixos-install --flake "$flake_url" --no-root-passwd
#
# Setup password for user (important!)
# $ mkdir /mnt/persist/passwords
# $ mkpasswd > /mnt/persist/passwords/uima
#
# After reboot:
#
# $ sudo chown uima:users /persist/passwords/uima

{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  system.stateVersion = "23.11";

  networking.hostName = "uifw";
  time.timeZone = "Asia/Taipei";

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  boot.loader.timeout = 0;

  # for cross compiling aarch64-linux image
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # hardware.framework.laptop13.audioEnhancement.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  hardware.keyboard.qmk.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true; # Allow .local hostnames to resolve

    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 3000 ];

  services.restic.backups = {
    remote = {
      # repository is in the env file
      paths = [
        "/persist"
      ];
      exclude = [
        "/persist/home/*/src/*/target"
        "/persist/home/*/src/*/.direnv"
        "/persist/home/*/dl"
        "/persist/var"
      ];
      environmentFile = "/persist/secrets/restic-remote-env";
      passwordFile = "/persist/secrets/restic-password";
      timerConfig = {
        OnBootSec = "15min";
        OnUnitActiveSec = "3hour";
        Persistent = true;
      };
      extraBackupArgs = [
        "--tag auto"
      ];
      pruneOpts = [
        "--tag auto"
        "--host=${config.networking.hostName}"
        "--group-by=host,paths"
        "--keep-last 10"
        "--keep-daily 7"
        "--keep-weekly 4"
      ];
      inhibitsSleep = true;
    };
  };

  # make a share dir
  # $ mkdir /share
  # $ chmod 2770 /share
  # $ setfacl -d -m g::rwx /share
  users.groups."share" = { };

  uimaConfig = {
    global.enable = true;

    users = {
      uima = {
        homeManager = true;
        extraGroups = [
          "share"
          "wheel"
          "networkmanager"
          "docker"
          "podman"
          "libvirtd"
        ];
      };

      araizen = {
        homeManager = true;
        extraGroups = [
          "share"
          "wheel"
          "networkmanager"
          "docker"
          "podman"
          "libvirtd"
        ];
      };
    };

    system = {
      sudo.enable = true;
      autoUpgrade.enable = true;

      impermanence = {
        enable = true;
        luksBtrfs.enable = true;
        luksBtrfs.device = "/dev/nvme0n1";

        directories = [
          "/share"
          "/var/lib/fprint"
        ];
      };
    };

    desktop = {
      wayland = {
        hyprland.enable = true;
        river.enable = true;
      };
    };

    networking = {
      networkmanager.enable = true;
      tailscale.enable = true;
    };

    hardware = {
      pipewire.enable = true;
      bluetooth.enable = true;
    };

    services = {
      udisks2.enable = true;

      systemdNotify.services."restic-backups-remote" = {
        onStart = ''--urgency=low 'Start Backup to B2...' '';
        onSuccess = ''--urgency=low 'Backup Success!' "Backup toke $duration seconds"'';
        onFailure = ''--urgency=normal 'Backup Failed!' "Backup filed at $duration seconds"'';
      };
    };

    virt = {
      vm.enable = true;
      docker.enable = true;
    };
  };

  sops.secrets =
    let
      hostSecrets = {
        sopsFile = ./secrets.yaml;
      };
    in
    {
      tailscale-auth-key = hostSecrets;
    };
}
