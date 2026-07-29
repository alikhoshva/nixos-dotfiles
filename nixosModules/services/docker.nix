{ pkgs, ... }: {
  # Enable common container config files in /etc/containers
  virtualisation.containers.enable = true;
  environment.etc."containers/policy.json".text = ''
    {
      "default": [
        {
          "type": "insecureAcceptAnything"
        }
      ],
      "transports": {
        "docker-daemon": {
          "": [
            {
              "type": "insecureAcceptAnything"
            }
          ]
        }
      }
    }
  '';
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Enable Docker socket emulation so docker-compose works seamlessly
      dockerSocket.enable = true;

      # Required for containers under podman-compose/docker-compose to talk to each other
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Useful development tools
  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    docker-compose # standard compose CLI (works with Podman via dockerSocket)
    podman-compose # podman-native compose tool
  ];
}
