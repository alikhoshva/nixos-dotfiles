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
      [ 0 0 55 ]               # Fan off below 55°C
      [ 1 46 68 ]              # Level 1 (~2000 RPM, near-silent) covers 55°C–68°C; drops to 0 at 46°C
      [ 3 58 78 ]              # Level 3 (~3000 RPM) covers 68°C–78°C; drops to Level 1 at 58°C
      [ 5 68 85 ]              # Level 5 (~3700 RPM) covers 78°C–85°C; drops to Level 3 at 68°C
      [ 7 76 90 ]              # Level 7 (~4500 RPM) covers 85°C–90°C; drops to Level 5 at 76°C
      [ "level auto" 84 32767 ]# Bios auto fallback for extreme safety
    ];
  };
}
