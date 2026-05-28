{ pkgs, ... }: {
  networking = {
    hostName = "nixos";

    # Standard wireless and proxy boilerplate (uncomment if needed)
    # wireless.enable = true;
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Rely on DHCP for primary DNS (e.g., a local AdGuard/Pi-hole)
    nameservers = [ ];

    timeServers =
      [ "time.cloudflare.com" "time.google.com" "0.us.pool.ntp.org" ];

    networkmanager = {
      enable = true;
      dns = "systemd-resolved"; # Hand off DNS control to resolved
    };
  };

  services.resolved = {
    enable = true;

    # Global fallback DNS when away from the home network
    fallbackDns = [ "1.1.1.1" "8.8.8.8" ];

    # 'opportunistic' prevents connection drops on restrictive public/corporate networks
    dnsovertls = "opportunistic";
  };
}
