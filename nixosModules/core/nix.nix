{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.optimise.automatic = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
