{ inputs, pkgs, ... }: {
  # Noctalia shell and required system services (UPower for battery & power status)
  services.upower.enable = true;

  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
