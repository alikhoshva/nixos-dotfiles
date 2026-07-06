{ pkgs, ... }:

{
  # Install GParted at system level so Polkit and pkexec elevate privileges correctly
  environment.systemPackages = with pkgs; [
    gparted
  ];
}
