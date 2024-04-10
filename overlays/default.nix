{ outputs, inputs }:

{
  # Adds custom packages
  additions = final: prev: import ../pkgs { pkgs = final; };
}
