{ writeShellApplication, pkgs, ... }:
writeShellApplication {
  name = "py";
  runtimeInputs = with pkgs; [
    (python313.withPackages (
      ps: with ps; [
        ipython
        rich
        requests
        httpx
        python-dateutil
        pygments
        numpy
        pandas
      ]
    ))
  ];

  text = ''
     exec python -i -c "
    import numpy as np
    import pandas as pd
    from rich.pretty import install; install()
    " "$@"
  '';
}
