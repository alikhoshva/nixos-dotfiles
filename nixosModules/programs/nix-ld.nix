{ pkgs, ... }:

{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # X11, Wayland & Display
      libxcomposite
      libxtst
      libxrandr
      libxext
      libx11
      libxfixes
      libGL
      libva
      pipewire
      libxcb
      libxdamage
      libxshmfence
      libxxf86vm
      libelf

      # System & Network
      glib
      networkmanager
      vulkan-loader
      libgbm
      libdrm
      libxcrypt
      coreutils
      pciutils
      zenity

      # Windowing & Desktop
      libxinerama
      libxcursor
      libxrender
      libxscrnsaver
      libxi
      libsm
      libice
      nspr
      nss
      cups
      libcap
      SDL2
      libusb1
      dbus-glib
      ffmpeg

      # Toolkits & Runtimes (Unity, GTK3, Electron)
      gtk3
      icu
      libnotify
      gsettings-desktop-schemas

      # Game & Audio Runtimes
      libxt
      libxmu
      libogg
      libvorbis
      SDL
      SDL2_image
      libidn
      tbb

      # Audio, Graphics & Media
      flac
      freeglut
      libjpeg
      libpng
      libsamplerate
      libmikmod
      libtheora
      libtiff
      pixman
      speex
      SDL_image
      SDL_ttf
      SDL_mixer
      SDL2_ttf
      SDL2_mixer
      libcaca
      libcanberra
      libgcrypt
      libvpx
      librsvg
      libxft
      libvdpau

      # Layout & Fonts
      pango
      cairo
      atk
      gdk-pixbuf
      fontconfig
      freetype
      dbus
      alsa-lib
      expat
      libxkbcommon

      # Compatibility & AppImages
      libxcrypt-legacy # For natron
      libGLU # For natron
      fuse # AppImages
      e2fsprogs
      gmp
      harfbuzz
      libgpg-error
      fribidi

      # Hardware & Scanners
      sane-backends
      pkcs11helper

      # Qt6 & Audio
      libpulseaudio
      krb5
      libxcb-cursor
      libxcb-wm
      libxcb-util
      libxcb-image
      libxcb-keysyms
      libxcb-render-util
    ];
  };
}

