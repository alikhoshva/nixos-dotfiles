{
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  # boot.loader.grub.memtest86.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel options.
  boot.kernelParams = [ "zswap.enabled=1" ];

  # Swap file configuration.
  swapDevices = [
    {
      device = "/swapfile"; # Location of the file
      size = 8192; # Size in MiB (e.g., 8192 = 8GiB)
    }
  ];
}
