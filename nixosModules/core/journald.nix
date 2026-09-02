{ ... }: {
  services.journald.extraConfig = ''
    SystemMaxUse=500M
    SystemMaxFileSize=100M
    MaxRetentionSec=1month
  '';

  systemd.coredump = {
    enable = true;
    settings.Coredump = {
      Storage = "external";
      MaxUse = "500M";
    };
  };
}
