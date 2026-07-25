{ inputs, pkgs-unstable, nixSource ? ../.., ... }:

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
        "${nixSource}/host/home.nix"
        (inputs.import-tree "${nixSource}/homeManagerModules")
      ];
    };
  };
}
