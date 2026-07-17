{ inputs, pkgs, ... }: {
  imports = [
    inputs.determinate.nixosModules.default
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.optimise.automatic = true;

  # Disable documentation generation to keep system slim
  documentation.nixos.enable = false;
  documentation.man.cache.enable = false;

  # Disable command-not-found legacy module which causes builtins.derivation warnings with Flakes
  programs.command-not-found.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
