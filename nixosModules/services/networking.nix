{ ... }: {
  programs.captive-browser = {
    enable = true;
    interface = "wlp1s0";
  };

  networking = {
    hostName = "nixos";

    timeServers = [
      "time.cloudflare.com"
      "time.google.com"
      "0.us.pool.ntp.org"
    ];

    networkmanager = {
      enable = true;
      dns = "systemd-resolved"; # Hand off DNS control to resolved
    };
  };

  services.resolved = {
    enable = true;

    settings = {
      Resolve = {
        MulticastDNS = "no";
        Domains = [ ];
        # Global fallback DNS when away from the home network
        FallbackDNS = [
          "1.1.1.1"
          "8.8.8.8"
        ];
        # 'opportunistic' prevents connection drops on restrictive public/corporate networks
        DNSOverTLS = "opportunistic";
      };
    };
  };
}
