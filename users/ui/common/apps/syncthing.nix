{ ... }:

{
  services.syncthing = {
    enable = true;
    extraOptions = [
      "--no-browser"
      "--no-default-folder"
    ];
  };
}
