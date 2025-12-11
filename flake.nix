# sudo nixos-rebuild build --flake .#Work
# sudo nixos-rebuild switch --flake .#Work

# sudo flake update

{
	inputs = { 
		nixpkgs.url      = "github:NixOS/nixpkgs/nixos-unstable";
		rahul-config.url = "github:rrbutani/nix-config";
		flake-utils.url  = "github:numtide/flake-utils";
		ragenix.url      = "github:yaxitech/ragenix";
		home-manager.url = "github:nix-community/home-manager";
		break-enforcer.url = "github:evavh/break-enforcer";
		home-automation.url = "github:yara-blue/HomeAutomation";
		tracy.url = "github:tukanoidd/tracy.nix";
		# break-enforcer.url = "path:/home/yara/bf/break-enforcer";

		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { ragenix, flake-utils, home-manager, rahul-config, nixpkgs, self,
	break-enforcer, home-automation, ... } @ inputs:
	let
	  inherit (nixpkgs) lib;
	  listDir = rahul-config.lib.util.list-dir;

		myOverlays = [
		  self.overlays.default ragenix.overlays.default
		  break-enforcer.overlays.default # makes break-enforcer available under pkgs
		  home-automation.overlays.default
		];

		special = system: {
		  inherit myOverlays inputs self;
		};

		machine = system: module: (lib.nixosSystem {
			specialArgs = { inherit myOverlays inputs; };
			system = system;
			modules = [ 
				module ./mixins/common.nix
				home-manager.nixosModules.home-manager {
					home-manager.useGlobalPkgs = true;
					home-manager.useUserPackages = true;
					home-manager.users.yara = ./home.nix;
				}
				module { home-manager.extraSpecialArgs = special system; }
				# make the nixos break-enforcer module available
				break-enforcer.nixosModules.break-enforcer
			];
		});
	in {

		 nixosConfigurations = {
			 Work = machine "x86_64-linux" ./hosts/work/main.nix;
		 };

		overlays.default = final: _: listDir {
		  of = ./pkgs; mapFunc = _: p: final.callPackage p {};
		};

	} // (flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system}.extend self.overlays.default;
    in with lib; {
      packages = pipe ./pkgs [
        (dir: listDir { of = dir; mapFunc = p: _: pkgs.${p}; })
        (filterAttrs (_: meta.availableOn pkgs.stdenv.hostPlatform))
        (filterAttrs (_: p: !(p.meta.broken or false)))
      ];
    })
  );
}
