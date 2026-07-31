{ pkgs, ... }: {
  services.greetd = {
    enable = true;
    settings = {
      # This block runs the login screen (tuigreet) BEFORE you log in.
      # It does not and should not mention Hyprland.
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
        user = "greeter";
      };
    };
  };
}
