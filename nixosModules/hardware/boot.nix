{
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = false;
  boot.loader.grub.extraEntries = ''
    menuentry "Windows Boot Manager" {
      insmod part_gpt
      insmod fat
      search --no-floppy --fs-uuid --set=root 9837-0DAD
      chainloader /EFI/Microsoft/Boot/bootmgfw.efi
    }
  '';
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Clean /tmp on boot
  boot.tmp.cleanOnBoot = true;

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
