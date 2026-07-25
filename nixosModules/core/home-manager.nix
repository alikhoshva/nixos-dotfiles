{ inputs, pkgs-unstable, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit pkgs-unstable;
    };
    users.aleks = {
      imports = [
        ../../host/home.nix
        (inputs.import-tree ../../homeManagerModules)
      ];
    };
  };
}
