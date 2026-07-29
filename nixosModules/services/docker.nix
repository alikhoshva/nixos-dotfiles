{ pkgs, ... }: {
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
    daemon.settings = {
      log-driver = "journald";
      dns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
  };

  # Useful development tools
  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    docker-compose # standard compose CLI
  ];
}
