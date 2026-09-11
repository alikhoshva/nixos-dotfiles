{ config, pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    walker
    elephant
  ];

  # Walker configuration & style symlinks
  xdg.configFile."walker/style.css".source = config.lib.file.mkOutOfStoreSymlink "/home/aleks/nixos-dotfiles/config/walker/style.css";
  xdg.configFile."walker/config.toml".source = config.lib.file.mkOutOfStoreSymlink "/home/aleks/nixos-dotfiles/config/walker/config.toml";

  systemd.user.services.elephant = {
    Unit = {
      Description = "Elephant launcher backend";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.unstable.elephant}/bin/elephant";
      Restart = "on-failure";
      RestartSec = 1;
      ExecStopPost = "${pkgs.coreutils}/bin/rm -f /tmp/elephant.sock";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.walker = {
    Unit = {
      Description = "Walker - Application Runner";
      ConditionEnvironment = "WAYLAND_DISPLAY";
      After = [
        "graphical-session.target"
        "elephant.service"
      ];
      Requires = [ "elephant.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.unstable.walker}/bin/walker --gapplication-service";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
