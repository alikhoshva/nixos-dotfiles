{ pkgs, ... }: {
  # Enable the Hyprland window manager without UWSM session management
  programs.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
    withUWSM = false;
  };
}


