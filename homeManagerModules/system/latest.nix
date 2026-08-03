{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    (ani-cli.overrideAttrs (oldAttrs: rec {
      version = "5.0";
      src = pkgs.fetchFromGitHub {
        owner = "pystardust";
        repo = "ani-cli";
        tag = "v${version}";
        hash = "sha256-rRQESi0Skoyf1jy/dRRK6ooKRPQhkak107kk5ulwZYI=";
      };
    }))
    dbeaver-bin
    devcontainer
    (yazi.override { _7zz = pkgs._7zz-rar; })
    #antigravity-fhs
    devenv
    pangolin-cli

  ];
}
