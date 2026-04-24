{ lib, config, ... }: {

  xdg.desktopEntries = {
    btop = {
      name = "btop";
      exec = "kitty --hold btop";
      terminal = false;
    };

    nvim = {
      name = "Neovim";
      exec = "nvim";
      terminal = true;
      noDisplay = true;
    };

    neovim = {
      name = "Neovim";
      comment = "Edit text files in Kitty";
      exec = "kitty nvim %U";
      terminal = false; # The desktop entry itself doesn't run in a terminal
      mimeType =
        [ "text/plain" "text/markdown" ]; # Associate it with text files
    };

    ani-media = {
      name = "Ani Media";
      comment = "Launch the ani-cli media application";
      exec = "kitty --hold ani-cli";
      terminal = false;
    };
  };

  xdg.userDirs = {
    enable = true;
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    videos = "${config.home.homeDirectory}/Media/Videos";
  };
  xdg.mimeApps.enable = lib.mkDefault true;
  xdg.configFile."mimeapps.list" =
    lib.mkIf config.xdg.mimeApps.enable { force = true; };
  xdg.mimeApps.defaultApplications = {
    # --- Set Thunar as default for folders ---
    "inode/directory" = "thunar.desktop";
    # --- Browser for web links ---
    "text/html" = "zen-twilight.desktop";
    "x-scheme-handler/http" = "zen-twilight.desktop";
    "x-scheme-handler/https" = "zen-twilight.desktop";
    # --- PDF Files ---
    "application/pdf" = "zen-twilight.desktop";
    # --- Text Files (now using our czen-twilightustom Neovim entry) ---
    "text/plain" = "neovim.desktop";
    "text/markdown" = "obsidian.desktop";
    "text/x-shellscript" = "neovim.desktop"; # For shell scripts

    # --- Images (using zen-twilight as a fallback) ---
    "image/jpeg" = "zen-twilight.desktop";
    "image/png" = "zen-twilight.desktop";
    "image/gif" = "zen-twilight.desktop";
    "image/webp" = "zen-twilight.desktop";

    # --- Videos (using zen-twilight as a fallback) ---
    "video/mp4" = "zen-twilight.desktop";
    "video/webm" = "zen-twilight.desktop";

    # --- Archives ---
    "application/zip" = "xarchiver.desktop";
    "application/x-rar-compressed" = "xarchiver.desktop";
    "application/x-7z-compressed" = "xarchiver.desktop";
    "application/x-tar" = "xarchiver.desktop";
    "application/gzip" = "xarchiver.desktop";
    "application/x-bzip2" = "xarchiver.desktop";
    "application/x-xz" = "xarchiver.desktop";

    # --- Office Documents ---
    "application/vnd.oasis.opendocument.text" = "libreoffice.desktop";
    "application/vnd.oasis.opendocument.spreadsheet" = "libreoffice.desktop";
    "application/vnd.oasis.opendocument.presentation" = "libreoffice.desktop";
    "application/msword" = "libreoffice.desktop";
    "application/vnd.ms-excel" = "libreoffice.desktop";
    "application/vnd.ms-powerpoint" = "libreoffice.desktop";
  };
}
