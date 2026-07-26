{ inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
    };
    users.aleks = {
      imports = [
        ../../host/home.nix
        (inputs.import-tree ../../homeManagerModules)
      ];
    };
  };
}
