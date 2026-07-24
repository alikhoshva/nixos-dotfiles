{
  # Enable PipeWire and WirePlumber for audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  services.pipewire.extraConfig.pipewire = {
    "98-crackling-fix" = {
      "context.properties" = {
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 1024;
        "default.clock.max-quantum" = 8192;
      };
    };
  };

  services.pipewire.wireplumber.extraConfig = {
    "99-crackling-fix" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            { "node.name" = "~alsa_input.*"; }
            { "node.name" = "~alsa_output.*"; }
          ];
          actions = {
            update-props = {
              "api.alsa.period-size" = 1024;
              "api.alsa.headroom" = 8192;
            };
          };
        }
      ];
    };
  };
}
