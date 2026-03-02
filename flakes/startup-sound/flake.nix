{
  description = "Play a sound when the system boots";

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
        soundFile = ./windows2000-logon.wav;
      in
      rec {
        packages = {
          store-pipewire-out = pkgs.writeShellApplication {
            name = "store-pipewire-out";
            runtimeInputs = with pkgs; [
			  coreutils-full
              pipewire
              jq
            ];
            text = ''
					# find a xdg_runtime_dir
					# shellcheck disable=SC2012
					first_user=$(${pkgs.coreutils-full}/bin/ls /run/user -1 | head -n 1)
					export XDG_RUNTIME_DIR=/run/user/$first_user

              		dump=$(pw-dump)
              		default_sink_name=$(echo "$dump" | jq --raw-output '.[]
              		  | select(.type=="PipeWire:Interface:Metadata")
              		  | .metadata[]
              		  | select(.key=="default.audio.sink")
              		  | .value.name')
              		default_sink_hw=$(echo "$dump" | jq --raw-output ".[] 
              			| select(.info.props.\"node.name\"==\"$default_sink_name\") 
              			| .info.props 
              			| \"hw:\(.\"alsa.card\"),\(.\"alsa.device\")\"")
              		echo "$default_sink_hw" > /var/cache/default_sink_hw
            '';
          };

          startup-sound = pkgs.writeShellApplication {
            name = "startup-sound";
            runtimeInputs = with pkgs; [
              alsa-utils
              coreutils-full
            ];
            text = ''
              			if device=$(cat /var/cache/default_sink_hw); then
              				aplay --device "$device" ${soundFile}
              			fi'';
          };
        };

        default = packages.startup-sound;
      }
    )
    // {
      overlays.default = _: prev: {
        startup-sound = self.packages.${prev.system}.startup-sound;
		store-pipewire-out = self.packages.${prev.system}.store-pipewire-out;
      };
      nixosModules.startup-sound = ./nix_module.nix;
    };
}
