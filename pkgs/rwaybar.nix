{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libpulseaudio,
  libxkbcommon,
  stdenv,
  wayland,
}:

rustPlatform.buildRustPackage rec {
  pname = "rwaybar";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "danieldg";
    repo = "rwaybar";
    rev = "v${version}";
    hash = "sha256-H22rgWMe80GTRBU5CqzTRQoD4tNqbebIjdhb3o6TCCQ=";
  };

  cargoHash = "sha256-nyqsEzFlTxJeOrcIiXPj8jY/zdLYjpjpArsKUCDkffU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libpulseaudio
    libxkbcommon
  ]
  ++ lib.optionals stdenv.isLinux [
    wayland
  ];

  meta = {
    description = "A taskbar for wayland compositors";
    homepage = "https://github.com/danieldg/rwaybar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "rwaybar";
  };
}
