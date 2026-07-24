{
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported Bluetooth adapters.
        Experimental = true;
      };
    };
  };

  services.blueman.enable = true;
}
