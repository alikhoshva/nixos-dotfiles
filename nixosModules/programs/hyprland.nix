{ pkgs, ... }: {
  # Enable the Hyprland window manager
  programs.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
  };
}


