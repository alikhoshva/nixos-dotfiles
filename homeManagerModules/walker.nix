{ inputs, ... }:

{
  imports = [ 
    inputs.walker.homeManagerModules.default 
  ];

  programs.elephant = {
    enable = true;
    installService = false;
  };

  programs.walker = {
    enable = true;
    runAsService = false;
  };

}
