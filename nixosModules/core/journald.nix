{ ... }: {
  services.journald.extraConfig = ''
    SystemMaxUse=500M
    SystemMaxFileSize=100M
    MaxRetentionSec=1month
  '';
}
