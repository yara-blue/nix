# based on the suggestion in https://github.com/typst/typst/issues/185
{
  description = "The newsreader font usable in typst";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        font-to-static = pkgs.writeShellApplication {
          name = "font-to-static";
          runtimeInputs = [ pkgs.python3Packages.fonttools ];
          text = ''
            			  src="$1"
            			  name="$(basename "$src" '.ttf')"
            			  for wght in 100 200 300 400 500 600 700 800 900; do
            				fonttools varLib.mutator -o "$name-$wght.ttf" "$src" wght="$wght"
            			  done
            		'';
        };
        newsreader = (pkgs.google-fonts.override { fonts = [ "Newsreader" ]; }).overrideAttrs (
          final: prev: {
            nativeBuildInputs = (prev.nativeBuildInputs or [ ]) ++ [ font-to-static ];

            preFixup = ''
              find "$out" -name '*.ttf' -execdir font-to-static '{}' ';'
            '';
          }
        );
      in
      {
        packages.default = newsreader;
      }
    )
    // {
      overlays.default = _: prev: {
        newsreader = self.packages.${prev.system}.default;
      };
    };
}
