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
      [
        0
        0
        50
      ]
      [
        4
        45
        70
      ]
      [
        7
        65
        85
      ]
      [
        "level auto"
        80
        32767
      ] # Max speed
    ];
  };

  services.upower.enable = true;
}
