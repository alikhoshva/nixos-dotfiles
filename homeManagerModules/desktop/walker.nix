{ config, lib, inputs, pkgs, ... }:

{
  imports = [ 
    inputs.walker.homeManagerModules.default 
  ];

  programs.elephant = {
    enable = true;
    installService = false;
    package = let
      overriddenElephant = inputs.elephant.packages.${pkgs.system}.elephant.overrideAttrs (old: {
        goModules = old.goModules.overrideAttrs (oldGoModules: {
          outputHash = "sha256-ssX+ZQ6v+XcwC/RuIZ+rO/9zZwZnotudj8bvZNM7M3g=";
        });
      });
      overriddenElephantProviders = inputs.elephant.packages.${pkgs.system}.elephant-providers.overrideAttrs (old: {
        goModules = old.goModules.overrideAttrs (oldGoModules: {
          outputHash = "sha256-ssX+ZQ6v+XcwC/RuIZ+rO/9zZwZnotudj8bvZNM7M3g=";
        });
      });
    in inputs.elephant.packages.${pkgs.system}.elephant-with-providers.overrideAttrs (old: {
      buildInputs = [
        overriddenElephant
        overriddenElephantProviders
      ];
      installPhase = ''
        mkdir -p $out/bin $out/lib/elephant
        cp ${overriddenElephant}/bin/elephant $out/bin/
        cp -r ${overriddenElephantProviders}/lib/elephant/providers $out/lib/elephant/
      '';
    });
  };

  programs.walker = {
    enable = true;
    runAsService = false;
  };

  # Override Walker module's generated config files with our out-of-store symlinks
  xdg.configFile."walker/style.css".source = config.lib.file.mkOutOfStoreSymlink "/home/aleks/nixos-dotfiles/config/walker/style.css";
  xdg.configFile."walker/config.toml".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "/home/aleks/nixos-dotfiles/config/walker/config.toml");
}
