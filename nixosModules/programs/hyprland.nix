{ pkgs, ... }: {
  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    withUWSM = false;
  };
}
