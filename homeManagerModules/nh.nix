{ pkgs, ... }: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 5";
    flake = "/home/aleks/nixos-dotfiles"; # sets NH_OS_FLAKE variable for you
  };
}
