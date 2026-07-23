{
  boot.extraModprobeConfig = ''
    options thinkpad_acpi fan_control=1
  '';

  services.thinkfan = {
    enable = true;
    sensors = [
      {
        type = "tpacpi";
        query = "/proc/acpi/ibm/thermal";
      }
    ];
    levels = [
      [ 0 0 52 ]
      [ 1 46 58 ]
      [ 2 53 65 ]
      [ 3 60 72 ]
      [ 5 68 80 ]
      [ 7 75 88 ]
      [ "level auto" 84 32767 ]
    ];
  };

  services.upower.enable = true;
}
