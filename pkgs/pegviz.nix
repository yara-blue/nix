{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "pegviz";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "fasterthanlime";
    repo = "pegviz";
    rev = "29834448d952c2cc9cb7a3a117395b5617b349f0";
    hash = "sha256-2ELin2JLT0hDSpkG4yQ7/i78enPo9T21MIeSKwS2Mgw=";
  };

  cargoHash = "sha256-YrJs83pfqxaClEqjyXJ3IUDA+cI+b+4DkldgAcid4cw=";

  meta = {
    description = "A visualizer for the rust peg parser traces";
    homepage = "https://github.com/fasterthanlime/pegviz";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "pegviz";
  };
}
