{ pkgs, ... }: {
  # Noctalia shell and required system services (UPower for battery & power status)
  services.upower.enable = true;

  environment.systemPackages = [
    pkgs.unstable.noctalia
  ];
}
