{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Interactive Tools
    btop
    powertop
    fastfetch # or neofetch
    wget
    lazydocker
    cachix
    nix-output-monitor # nom - provides interactive build logs & graphs
    #devpod-desktop
    # Scripting Dependencies
    jq
    socat
    vlc
  ];

  programs.starship.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true; # This handles the 'hook' automatically
  };
}
