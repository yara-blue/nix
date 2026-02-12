# sudo nixos-rebuild build --flake .#Work
# sudo nixos-rebuild switch --flake .#Work

# sudo flake update

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    rahul-config.url = "github:rrbutani/nix-config";
    flake-utils.url = "github:numtide/flake-utils";
    ragenix.url = "github:yaxitech/ragenix";
    ragenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix-rekey.url = "github:oddlama/agenix-rekey";
    agenix-rekey.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    break-enforcer.url = "github:evavh/break-enforcer";
    break-enforcer.inputs.nixpkgs.follows = "nixpkgs";
    home-automation.url = "github:yara-blue/HomeAutomation";
    tracy.url = "github:tukanoidd/tracy.nix";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zed.url = "github:zed-industries/zed";
    zed.inputs.nixpkgs.follows = "nixpkgs";
    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
    nixcord.url = "github:FlameFlag/nixcord";
  };

  outputs =
    {
      ragenix,
      agenix-rekey,
      flake-utils,
      home-manager,
      rahul-config,
      nixpkgs,
      self,
      break-enforcer,
      home-automation,
      stylix,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      listDir = rahul-config.lib.util.list-dir;

      myOverlays = [
        self.overlays.default
        ragenix.overlays.default
        agenix-rekey.overlays.default
        break-enforcer.overlays.default # makes break-enforcer available under pkgs
        home-automation.overlays.default
      ];

      machine =
        system: hostname:
        lib.nixosSystem {
          specialArgs = { inherit myOverlays inputs hostname; };
          system = system;
          modules = [
            ./hosts/${hostname}/main.nix
            ./mixins/common.nix
			stylix.nixosModules.stylix
            ragenix.nixosModules.default
            agenix-rekey.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.yara = ./home.nix;
            }
            {
              home-manager.extraSpecialArgs = {
                inherit
                  myOverlays
                  inputs
                  system
                  hostname
                  ;
              };
            }
            # make the nixos break-enforcer module available
            break-enforcer.nixosModules.break-enforcer
          ];
        };
    in
    {

      nixosConfigurations = {
        Work = machine "x86_64-linux" "work";
        Abydos = machine "x86_64-linux" "abydos";
      };

      agenix-rekey = agenix-rekey.configure {
        userFlake = self;
        nixosConfigurations = self.nixosConfigurations;
      };

      overlays.default =
        final: _:
        listDir {
          of = ./pkgs;
          mapFunc = _: p: final.callPackage p { };
        };

    }
    // (flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.extend self.overlays.default;
      in
      with lib;
      {
        packages = pipe ./pkgs [
          (
            dir:
            listDir {
              of = dir;
              mapFunc = p: _: pkgs.${p};
            }
          )
          (filterAttrs (_: meta.availableOn pkgs.stdenv.hostPlatform))
          (filterAttrs (_: p: !(p.meta.broken or false)))
        ];
      }
    ))
    // (flake-utils.lib.eachDefaultSystem (system: rec {
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ agenix-rekey.overlays.default ];
      };
      devShells.default = pkgs.mkShell {
        packages = [ pkgs.agenix-rekey ];

      };
    }));

}
