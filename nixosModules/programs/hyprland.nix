{ pkgs, ... }: {
  # Enable the Hyprland window manager with UWSM session management
  programs.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
    withUWSM = true;
  };
}


