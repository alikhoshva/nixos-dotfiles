{ pkgs, inputs, ... }: {
  nix.package = pkgs.lix;
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    warn-dirty = false;
  };

  nix.optimise.automatic = true;

  # Disable documentation generation to keep system slim
  documentation.nixos.enable = false;
  documentation.man.cache.enable = false;

  # Disable command-not-found legacy module which causes builtins.derivation warnings with Flakes
  programs.command-not-found.enable = false;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = prev.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    })
  ];

  environment.systemPackages = [
    pkgs.home-manager
  ];
}
