{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Python Environment
    python3
    
    # Javascript Environment & Package Managers
    nodejs # Includes corepack, npm, etc.
  ];
}
