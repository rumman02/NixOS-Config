{
  description = "Ultimate Nixos Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-alt.url = "github:NixOS/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixcat (neovim manager by nix)
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    # stylix
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-alt,
    home-manager,
    ...
  }@inputs:
    let
      defaultSys = "x86_64-linux";
      defaultStateV = "25.05";
      # function
      mkPkgs =
        pkgsSource: system:
        import pkgsSource {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
        };
      pkgsPri = mkPkgs nixpkgs;
      pkgsAlt = mkPkgs nixpkgs-alt;

      # system
      mkSystem = {
        system ? defaultSys,
        specialArgs ? { },
        modules ? [ ],
        homedir,
        configdir,
        hostname,
        username,
        stateversion ? defaultStateV,
      }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = pkgsPri system;
          specialArgs = {
            alt = pkgsAlt system;
            inherit
            homedir
            hostname
            username
            configdir
            stateversion
            inputs
            ;
          }
            // specialArgs;
          modules = [
            ./hosts/${hostname}/configuration.nix
          ]
            ++ modules;
        };

      # home
      mkHome = {
        system ? defaultSys,
        extraSpecialArgs ? { },
        modules ? [ ],
        homedir,
        configdir,
        hostname,
        username,
        stateversion ? defaultStateV,
      }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsPri system;
          extraSpecialArgs = {
            alt = pkgsAlt system;
            inherit
            system
            homedir
            hostname
            username
            configdir
            stateversion
            inputs
            ;
          }
            // extraSpecialArgs;
          modules = [
            ./homes/${username}/home.nix
          ]
            ++ modules;
        };
    in {
    };
}