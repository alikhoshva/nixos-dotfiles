{ inputs, pkgs, ... }: {

  home.packages = [
    #inputs.viu.packages.${pkgs.stdenv.hostPlatform.system}.default
    #inputs.swww.packages.${pkgs.stdenv.hostPlatform.system}.swww
    inputs.anipy-cli.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.nvim-config.packages.${pkgs.stdenv.hostPlatform.system}.default
    #(inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    #  _7zz = pkgs._7zz-rar;
    #})

  ];

}
