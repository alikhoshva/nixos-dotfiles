{
  services.tlp = {
    enable = true;
    settings = {
      TLP_ENABLE = 1;

      # CPU scaling governor (for amd-pstate-epp powersave is recommended for both AC & BAT)
      CPU_SCALING_GOVERNOR_ON_AC = "powersave";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Energy Performance Preference (EPP) for AMD CPPC / HW P-States
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      # ACPI Platform Profiles (ThinkPad firmware profiles)
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "balanced";

      # AMD CPU Core Boost (enabled on AC, disabled on BAT for power efficiency)
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # ThinkPad Battery Health Protection
      START_CHARGE_THRESH_BAT0 = 60;
      STOP_CHARGE_THRESH_BAT0 = 95;
      RESTORE_THRESH_AFTER_DETACH = 1; # Re-apply charge thresholds when AC is reconnected

      # Power management for PCI Express, Runtime PM, and Wi-Fi
      PCIE_ASPM_ON_BAT = "powersave";
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";
      WIFI_PWR_ON_BAT = "on";
    };
  };
}

