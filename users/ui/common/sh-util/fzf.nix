{ ... }:

{
  programs.fzf = {
    enable = true;

    defaultOptions = [
      "--height 50%"
      "--color=pointer:5,gutter:-1"
      "--no-separator"
      "--info=inline"
      "--reverse"
    ];

    defaultCommand = "fd -HL --exclude '.git' --type file";
  };
}
