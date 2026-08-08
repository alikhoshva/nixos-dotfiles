{ pkgs, config, ... }: {
  home.packages = with pkgs; [ papirus-folders ];

  gtk = {
    enable = true;
    gtk4.theme = config.gtk.theme;
    theme = {
      name = "Breeze-Dark";
      package = pkgs.kdePackages.breeze-gtk;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "lavender";
      };
    };

    # Force legacy GTK apps to use dark theme (dconf handles modern apps)
    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      "color-scheme" = "prefer-dark";
      "text-scaling-factor" = 1.0;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "catppuccin-mocha-light-cursors";
    package = pkgs.catppuccin-cursors.mochaLight;
    size = 24;
  };

  home.sessionVariables = {
    XCURSOR_SIZE = "24";
    HYPRCURSOR_SIZE = "24";
    XCURSOR_THEME = "catppuccin-mocha-light-cursors";
    HYPRCURSOR_THEME = "catppuccin-mocha-light-cursors";
  };
}
