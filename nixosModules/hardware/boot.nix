{
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # AMD GPU & Kernel options.
  hardware.amdgpu.initrd.enable = true;
  boot.kernelParams = [
    "zswap.enabled=1"
    "amdgpu.gpu_recovery=1"
    "amdgpu.abmlevel=0"
  ];

  # Swap file configuration.
  swapDevices = [
    {
      device = "/swapfile"; # Location of the file
      size = 8192; # Size in MiB (e.g., 8192 = 8GiB)
    }
  ];
}
