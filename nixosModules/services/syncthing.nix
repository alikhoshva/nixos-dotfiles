{
  services.syncthing = {
    enable = true;
    user = "aleks";
    dataDir = "/home/aleks";
    configDir = "/home/aleks/.config/syncthing";
    openDefaultPorts = true;
    overrideFolders = false;

    settings = {
      folders = {
        "ftb-skies-2-map" = {
          path = "/home/aleks/.local/share/PrismLauncher/instances/FTB Skies 2- Aero(1)/.minecraft/local";
          id = "ftb-skies-2-map";
          label = "FTB Skies 2 - Map & Local Data";
          type = "sendreceive"; # Full two-way sync between NixOS and Windows
          ignorePatterns = [
            "crash_assistant"
            "kubejs/export"
            "kubejs/exported_packs"
          ];
          versioning = {
            type = "simple";
            params.keep = "5"; # Keep 5 backup versions in case of conflicts or accidental edits
          };
        };
      };
    };
  };
}
