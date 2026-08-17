{ pkgs, ... }:
let
  scale-wrap = pkgs.writeShellScriptBin "scale-wrap" ''
    SCALE=$(cat "$HOME/.config/ui_scale" 2>/dev/null || echo 1.333333)
    BIN="$1"
    shift
    ARGS=()
    for arg in "$@"; do
      case "$arg" in
        %U|%u|%F|%f) ;;
        *) ARGS+=("$arg") ;;
      esac
    done
    exec "$BIN" --force-device-scale-factor="$SCALE" "''${ARGS[@]}"
  '';

  mkScaledApp = name: bin: icon: cat: {
    inherit name icon;
    exec = "${scale-wrap}/bin/scale-wrap ${bin} %U";
    categories = [ cat ];
  };
in
{
  home.packages = [ scale-wrap ];

  xdg.desktopEntries = {
    vivaldi-stable = mkScaledApp "Vivaldi" "vivaldi" "vivaldi" "Network";
    vesktop = (mkScaledApp "Vesktop" "vesktop" "vesktop" "Network") // {
      exec = "${scale-wrap}/bin/scale-wrap vesktop --ozone-platform=wayland --enable-features=WebRTCPipeWireCapturer,WaylandWindowDecorations %U";
    };
    spotify = mkScaledApp "Spotify" "spotify" "spotify-client" "Audio";
    code = mkScaledApp "Visual Studio Code" "code" "vscode" "Development";
    antigravity-ide =
      mkScaledApp "Google Antigravity IDE" "antigravity-ide" "antigravity-ide"
        "Development";
  };
}
