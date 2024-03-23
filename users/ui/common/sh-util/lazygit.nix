{ pkgs, ... }:

{
  home.shellAliases = {
    lg = "lazygit";
  };

  home.packages = with pkgs; [
    delta
  ];

  programs.lazygit = {
    enable = true;

    settings = {
      gui = {
        theme = {
          # TODO: theme support
          inactiveBorderColor = ["#777777"];
        };
        showBottomLine = false;
      };
      git = {
        paging = {
          colorArg =  "always";
          pager = "delta --dark --paging=never";
        };
      };
    };
  };
}
