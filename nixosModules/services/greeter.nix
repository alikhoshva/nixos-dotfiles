{ pkgs, ... }: {
  services.greetd = {
    enable = true;
    settings = {
      # This block runs the login screen (tuigreet) BEFORE you log in.
      # It does not and should not mention Hyprland.
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd \"uwsm start hyprland-uwsm.desktop\"";
        user = "greeter";
      };
    };
  };

  # Keep tuigreet package bundled with the greeter service configuration
  environment.systemPackages = with pkgs; [ tuigreet ];
}
