{ outputs, inputs }:

{
  # Adds custom packages
  additions = final: prev:
    import ../pkgs { pkgs = final; }
    // {
      tmuxPlugins = (prev.tmuxPlugins or { }) // import ../pkgs/tmux-plugins { pkgs = final; };
    };

  dwm = final: prev: {
    dwm = prev.dwm.overrideAttrs { src = ../pkgs/dwm; };
  };
  st = final: prev: {
    st = prev.st.overrideAttrs { src = ../pkgs/st; };
  };
}
