{ pkgs, ... }: {
  programs.thunar.enable = true;

  programs.thunar.plugins = with pkgs; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.udisks2.enable = true; # Disk management and mounting service
}

