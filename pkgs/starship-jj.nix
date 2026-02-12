{
  lib,
  rustPlatform,
}:
rustPlatform.buildRustPackage {
  pname = "starship-jj";
  version = "0.7.0";

  src = fetchGit {
    url = "https://gitlab.com/lanastara_foss/starship-jj";
    ref = "feature/extended_color_parsing";
    rev = "e2fe1544fe92198427a1fcc1dfad9dbccf93ce79";
  };

  cargoHash = "sha256-PTgZebzYvRfDgu7/mNTxI864fwIklRFRhLqQCqBlGo0=";

  meta = with lib; {
    description = "Starship plugin for jj";
    homepage = "https://gitlab.com/lanastara_foss/starship-jj";
    maintainers = with maintainers; [
      nemith
    ];
    license = licenses.mit;
  };
}
