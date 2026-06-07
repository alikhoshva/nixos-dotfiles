{
  description = "NixOS from Scratch";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #hyprland.url = "github:hyprwm/Hyprland?submodules=1";
    #viu.url = "github:Benexl/viu";
    #swww.url = "github:LGFae/swww";
    anipy-cli.url = "github:sdaqo/anipy-cli";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nvim-config = {
      url = "git+file:///home/aleks/Projects/Personal/nvim-config";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    #yazi.url = "github:sxyazi/yazi";
  };

  outputs = inputs:
    let
      system = "x86_64-linux";
      lib = inputs.nixpkgs.lib;
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
          };
          modules = [ ./host/configuration.nix ./nixosModules ];
        };
      };
      
      homeConfigurations = {
        aleks = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
          };
          modules = [ ./host/home.nix ];
        };
      };

      homeManagerModules.default = import ./homeManagerModules;
    };
}
