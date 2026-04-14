{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Interactive Tools
    btop
    powertop
    fastfetch # or neofetch
    wget
    git
    lazydocker
    cachix
    #devpod-desktop
    jdk17
    # Scripting Dependencies
    jq
    socat
    fzf
    vlc
  ];
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true; # This handles the 'hook' automatically
  };
}
