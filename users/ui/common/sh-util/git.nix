{ config, ... }:

# TODO: manage git key

{
  programs.git = {
    enable = true;

    aliases = {
      s = "status";
    };

    userName = "luck07051";
    userEmail = "luck07051@gmail.com";
  };
}
