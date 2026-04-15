# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, pkgs-unstable, ... }:

{
  imports = [ # Include the results of the hardware scan.
    inputs.home-manager.nixosModules.home-manager
    ./home-manager.nix
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  nix.optimise.automatic = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = false;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };
  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aleks = {
    isNormalUser = true;
    description = "Aleks Likhoshva";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  boot.kernelParams = [ "zswap.enabled=1" ];

  # This creates a low-priority, "last resort" swap file on your disk.
  swapDevices = [{
    device = "/swapfile"; # Location of the file
    size = 8192; # Size in MiB (e.g., 8192 = 8GiB)
  }];

  services.upower.enable = true;

  # Enable fonts
  fonts.packages = with pkgs; [
    fira-sans
    font-awesome
    roboto
    # It's also a good idea to have a fallback for emojis and other symbols
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    nerd-fonts.code-new-roman
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu
  ];

  # Enable PipeWire and WirePlumber for audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = false;
    wireplumber.enable = true;
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

  # additional fix for very bad devices or VM. 
  services.pipewire.wireplumber.extraConfig = {
    "99-crackling-fix" = {
      "api.alsa.period-size" = 1024;
      "api.alsa.headroom" = 8192;
    };
  };

  boot.extraModprobeConfig = ''
    options thinkpad_acpi fan_control=1
  '';

  services.thinkfan = {
    enable = true;
    sensors = [{
      type = "tpacpi";
      query = "/proc/acpi/ibm/thermal";
    }];
    levels = [
      [ 0 0 50 ]
      [ 4 45 70 ]
      [ 7 65 85 ]
      [ "level auto" 80 32767 ] # Max speed
    ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [ cups-filters cups-browsed ];
  };
  services.logind.settings.Login.HandleLidSwitchDocked = "ignore";
  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  environment.systemPackages = with pkgs; [ tuigreet ];

  system.stateVersion = "25.11"; # Did you read the comment?
}
