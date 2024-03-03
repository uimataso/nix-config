{ ... }:

# TODO:
# manage git key

{
  programs.git = {
    enable = true;

    aliases = {
      s = "status";
    };

    delta.enable = true;

    userName = "luck07051";
    userEmail = "luck07051@gmail.com";
  };
}
