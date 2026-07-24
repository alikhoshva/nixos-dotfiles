{ ... }:

{
  # udev rules for Everglide SU75 Pro keyboard WebHID support
  services.udev.extraRules = ''
    # Everglide SU75 Pro WebHID access
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="1ca6", ATTRS{idProduct}=="3002", MODE="0666", TAG+="uaccess"
  '';
}
