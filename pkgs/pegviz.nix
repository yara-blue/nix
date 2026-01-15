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
    rev = "v${version}";
    hash = "sha256-H22rgWMe80GTRBU5CqzTRQoD4tNqbebIjdhb3o6TCCQ=";
  };

  cargoHash = "sha256-nyqsEzFlTxJeOrcIiXPj8jY/zdLYjpjpArsKUCDkffU=";

  meta = {
    description = "A visualizer for the rust peg parser traces";
    homepage = "https://github.com/fasterthanlime/pegviz";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "pegviz";
  };
}
