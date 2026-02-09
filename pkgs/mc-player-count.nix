{
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "mc-player-count";
  version = "0.2.0"; # does not need to match the Cargo version field

  src = fetchFromGitHub {
    owner = "yara-blue";
    repo = "mc-player-count";
    rev = "68910edf55f773adbe142682803d7a85f1a54cce";
    hash = "sha256-rmdlfmVSLii2O6UQKSivmed5AgrIBClray5wcmNsCCU=";
  };

  cargoHash = "sha256-XIRjEfCzAjbKcjGRc57xy1OS3WrhaZP+FnvI8udQuRk=";

  meta = {
    description = "Small bar app which displays the number of players on a
	minecraft server as a single number";
    homepage = "https://github.com/yara-blue/mc-player-count";
    maintainers = [ ];
    mainProgram = "mc-player-count";
  };
}
