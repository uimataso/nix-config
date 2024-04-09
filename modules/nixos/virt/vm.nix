{ config, lib, pkgs, ... }:

# TODO: direct GPU render

with lib;

let
  cfg = config.myConfig.virt.vm;
in
{
  options.myConfig.virt.vm = {
    enable = mkEnableOption "vm";
  };

  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [
      virt-viewer
      spice
      spice-gtk
      spice-protocol
    ];

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          swtpm.enable = true;
          ovmf.enable = true;
          ovmf.packages = [ pkgs.OVMFFull.fd ];
        };
      };
      spiceUSBRedirection.enable = true;
    };

    services.spice-vdagentd.enable = true;
  };
}
