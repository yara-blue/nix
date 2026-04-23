{
  description = "Scaffold a minimal Rust playground and jump to it from your shell";

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
        cargo_toml = ./rust_Cargo.toml;
        main = ./rust_main.rs;
        flake = ./rust_flake.nix;
        toolchain = ./rust_toolchain.toml;
    		envrc = ./rust_envrc;
        playground = pkgs.writeShellApplication {
          name = "playground";
          text = ''
            name=$(date +%4Y-%m-%d_%Hh%M)
            path=$HOME/tmp/playgrounds/$name
            mkdir -p "$HOME/tmp/playgrounds"

            for i in {0..10}; do
              if mkdir "$path"; then
                break
              fi
              path="$HOME/tmp/playgrounds/$\{name\}_$i"
            done

            cp --no-preserve=mode,ownership ${flake} "$path/flake.nix"
            cp --no-preserve=mode,ownership ${envrc} "$path/.envrc"
            cp --no-preserve=mode,ownership ${cargo_toml} "$path/Cargo.toml"
            cp --no-preserve=mode,ownership ${toolchain} "$path/rust-toolchain.toml"
            mkdir "$path/src"
            cp --no-preserve=mode,ownership ${main} "$path/src/main.rs"

            direnv allow "$path"
            echo "$path"
          '';
        };
        cd-playground = pkgs.writeShellApplication {
          name = "cd-playground";
          text = ''
            if ! ls "$HOME/tmp/playgrounds" > /dev/null; then
              ${playground}/bin/playground
              exit 1
            fi

            find "$HOME/tmp/playgrounds" -maxdepth 1 -mindepth 1 | sort | head -n 1
          '';
        };
      in
      {
        packages = {
          default = playground;
          cd-playground = cd-playground;
        };
      }
    )
    // {
      overlays.default = _: prev: {
        playground = self.packages.${prev.system}.default;
      };

      homeManagerModules.default = import ./hm-module.nix self;
    };
}
