{ pkgs, ... }:
let
  scale-wrap = pkgs.writeShellScriptBin "scale-wrap" ''
    SCALE=$(cat "$HOME/.config/ui_scale" 2>/dev/null || echo 1.0)
    CURSOR_SIZE=$(awk "BEGIN {print int(24 * $SCALE + 0.5)}")
    DPI=$(awk "BEGIN {print int($SCALE * 96 + 0.5)}")
    export XCURSOR_SIZE="$CURSOR_SIZE"
    export HYPRCURSOR_SIZE="$CURSOR_SIZE"
    export GTK_CURSOR_SIZE="$CURSOR_SIZE"
    export XCURSOR_THEME="catppuccin-mocha-light-cursors"
    export HYPRCURSOR_THEME="catppuccin-mocha-light-cursors"

    printf "Xft.dpi: %s\nXcursor.size: %s\nXcursor.theme: catppuccin-mocha-light-cursors\n" "$DPI" "$CURSOR_SIZE" | ${pkgs.xorg.xrdb}/bin/xrdb -merge 2>/dev/null
    exec "$1" --force-device-scale-factor="$SCALE" "''${@:2}"
  '';

  mkScaledApp = name: bin: icon: cat: {
    inherit name icon;
    exec = "${scale-wrap}/bin/scale-wrap ${bin} %U";
    categories = [ cat ];
  };
in
{
  home.packages = [ scale-wrap pkgs.xorg.xrdb ];

  xdg.desktopEntries = {
    vivaldi-stable  = mkScaledApp "Vivaldi" "vivaldi" "vivaldi" "Network";
    spotify         = mkScaledApp "Spotify" "spotify" "spotify-client" "Audio";
    code            = mkScaledApp "Visual Studio Code" "code" "vscode" "Development";
    antigravity-ide = mkScaledApp "Google Antigravity IDE" "antigravity-ide" "antigravity-ide" "Development";
  };
}
