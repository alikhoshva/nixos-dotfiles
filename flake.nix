{
  description = "NixOS from Scratch";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #anipy-cli.url = "github:sdaqo/anipy-cli";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    noctalia = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nvim-config = {
      url = "git+file:///home/aleks/Projects/Personal/nvim-config";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    elephant.url = "github:abenz1267/elephant";
    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    import-tree.url = "github:denful/import-tree";
  };

  outputs =
    inputs:
    let
      system = "x86_64-linux";
      lib = inputs.nixpkgs.lib;
      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
          };
          modules = [
            ./host/configuration.nix
            (inputs.import-tree ./nixosModules)
          ];
        };
      };

      homeConfigurations = {
        aleks = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                #"pnpm-10.29.2"
              ];
            };
          };
          extraSpecialArgs = {
            inherit inputs;
            inherit pkgs-unstable;
          };
          modules = [
            ./host/home.nix
            (inputs.import-tree ./homeManagerModules)
          ];
        };
      };

      homeManagerModules.default = inputs.import-tree ./homeManagerModules;
    };
}
