{ inputs, pkgs, pkgs-unstable, ... }: {
  # Enable the Hyprland window manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # set the flake package
    #package =
    #  inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    #portalPackage =
    #  inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    # Set the package to the unstable version
    package = pkgs-unstable.hyprland;
    
    # Make sure to also set the portal package, so that they are in sync
    portalPackage = pkgs-unstable.xdg-desktop-portal-hyprland;
  };
}
