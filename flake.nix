{
  description = "Configurations of Aurel";

  outputs = {
    self,
    home-manager,
    nixpkgs,
    nixpkgs-stable,
    ...
  } @ inputs: let
    systemSettings = {
      system = "x86_64-linux";
      hostname = "nixos";
      host = "desktop";
    };
    userSettings = {
      username = "aurel";
      dotfilesDir = "~/.dotfiles";
    };

    lib = nixpkgs.lib;

    pkgs = import nixpkgs {
      system = systemSettings.system;
      config.allowUnfree = true;
    };

    pkgs-stable = import nixpkgs-stable {
      system = systemSettings.system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.system = lib.nixosSystem {
      system = systemSettings.system;
      specialArgs = {
        inherit inputs pkgs-stable;
        inherit userSettings systemSettings;
      };
      modules = [
        ./nixos/nixos.nix
      ];
    };

    homeConfigurations.user = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs pkgs-stable;
        inherit userSettings systemSettings;
      };
      modules = [
        ./home-manager/home.nix
      ];
    };
  };

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    ags.url = "github:Aylur/ags";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lf-icons = {
      url = "github:gokcehan/lf";
      flake = false;
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
