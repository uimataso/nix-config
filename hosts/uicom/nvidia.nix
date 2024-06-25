{ ... }:

# https://discourse.nixos.org/t/getting-nvidia-to-work-avoiding-screen-tearing/10422/16

{
  hardware.nvidia = {
    modesetting.enable = true;
    #powerManagement.enable = false;
    prime = {
      nvidiaBusId = "PCI:1:0:0";
      intelBusId = "PCI:0:1:0";
      sync.enable = true;
    };
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    config = ''
      Section "Device"
          Identifier  "nvidia"
          Driver      "nvidia"
          BusID       "PCI:1:0:0"
          Option      "AllowEmptyInitialConfiguration"
          Option      "TearFree"  "true"
      EndSection
    '';

    screenSection = ''
      Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "on"
    '';

    xrandrHeads = [ "HDMI-0" ];
  };
}
