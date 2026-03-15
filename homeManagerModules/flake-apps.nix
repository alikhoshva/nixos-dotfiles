{ inputs, pkgs, ... }: {

  home.packages = [
    inputs.viu.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.swww.packages.${pkgs.stdenv.hostPlatform.system}.swww
    (inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
      _7zz = pkgs._7zz-rar;
    })

  ];
}
