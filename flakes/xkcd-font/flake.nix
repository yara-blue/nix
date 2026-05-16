{
  description = "xkcd handwriting fonts from https://github.com/ipython/xkcd-font";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    xkcd-font-src = {
      url = "github:ipython/xkcd-font/2ae732fe59a997c57182c0964e19c2a50e2b0a4f";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      xkcd-font-src,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # CC BY-NC 3.0 apparently unfree 
          config.allowUnfree = true;
        };
        xkcd-font = pkgs.stdenvNoCC.mkDerivation {
          pname = "xkcd-font";
          version = "commit-2ae732f";

          src = xkcd-font-src;

          dontConfigure = true;
          dontBuild = true;

          installPhase = ''
            runHook preInstall

            install -Dm644 xkcd-script/font/xkcd-script.ttf \
              "$out/share/fonts/truetype/xkcd-script.ttf"
            install -Dm644 xkcd-script/font/xkcd-script.otf \
              "$out/share/fonts/opentype/xkcd-script.otf"
            install -Dm644 xkcd/build/xkcd.otf \
              "$out/share/fonts/opentype/xkcd.otf"
            install -Dm644 xkcd/build/xkcd-Regular.otf \
              "$out/share/fonts/opentype/xkcd-Regular.otf"

            install -Dm644 LICENSE \
              "$out/share/doc/xkcd-font/LICENSE"
            install -Dm644 README.md \
              "$out/share/doc/xkcd-font/README.md"

            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "Fonts derived from the handwriting of Randall Munroe (xkcd)";
            homepage = "https://github.com/ipython/xkcd-font";
            license = licenses.cc-by-nc-30;
          };
        };
      in
      {
        packages.default = xkcd-font;
        packages.xkcd-font = xkcd-font;
      }
    )
    // {
      overlays.default = _: prev: {
        xkcd-font = self.packages.${prev.system}.default;
      };
    };
}
