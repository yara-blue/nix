{
  description = "Shutdown the system when it's time to go to bed";

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
		soundFile = ./windows2000_logoff.wav;
        go-to-bed = pkgs.writeShellApplication {
          name = "go-to-bed";
          runtimeInputs = with pkgs; [
            systemd
            libnotify
            alsa-utils
          ];
          text = ''
			if [ "$EUID" -ne 0 ]
			  then echo "Please run as root"
			  exit
			fi

			if [[ " $* " == *" --play-sound "* ]]; then
				# find a xdg_runtime_dir
				# shellcheck disable=SC2012
				first_user=$(${pkgs.coreutils-full}/bin/ls /run/user -1 | head -n 1)
				export XDG_RUNTIME_DIR=/run/user/$first_user
				aplay ${soundFile}
			fi

			if [[ " $* " == *" --notifications "* ]]; then
				last_id=5
				for i in {0..30}; do
					last_id=$(notify-send \
						--urgency=critical \
						--replace-id="$last_id"
						"System will shutdown in $((30 - i))s")
					sleep 1
				done
			fi
			systemctl poweroff
				  '';
        };
      in
      {
        defaultPackage = go-to-bed;
      }
    )
    // {
      overlays.default = _: prev: {
        go-to-bed = self.defaultPackage.${prev.system};
      };
      nixosModules.go-to-bed = ./nix_module.nix;
    };
}
