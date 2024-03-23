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
      "--bind=tab:down"
    ];

    defaultCommand = "fd -HL --exclude '.git' --type file";
  };
}
