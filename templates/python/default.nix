{ python311Packages }:

python311Packages.buildPythonApplication {
  pname = "{{CODENAME}}";
  version = "0.1.0";
  # format = "pyproject";

  src = ./.;

  propagatedBuildInputs = [
    python311Packages.setuptools
  ];
}
