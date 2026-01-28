{
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "mc-player-count";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "yara-blue";
    repo = "mc-player-count";
    rev = "f11ed61554743851a593f15e6b476974a90d82d4";
    hash = "sha256-HqldwhQwbf+7/fZv96Q+MSeFVa6DCEol02C0ZDrGAD8=";
  };

  cargoHash = "sha256-7faVh5j029L3KNRVii+oGwFt4lUb3gjnbcqdv62ekHE=";

  meta = {
    description = "Small bar app which displays the number of players on a
	minecraft server as a single number";
    homepage = "https://github.com/yara-blue/mc-player-count";
    maintainers = [ ];
    mainProgram = "mc-player-count";
  };
}
