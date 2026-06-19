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

    # Walker uses a standard configuration structure
    config = {
      app_launch_prefix = "";
      terminal = "kitty";
      
      # Since we are keeping it strictly as a standard app launcher for now,
      # we can disable the other built-in modules or just rely on the defaults.
      # We will just rely on the defaults which includes apps.
    };
  };

  # Port the wofi CSS over to Walker's styling
  xdg.configFile."walker/style.css".text = ''
    @import url("/home/aleks/.cache/wal/colors-wofi.css");

    #window {
      background-color: rgba(22, 22, 28, 0.6);
      border-radius: 18px;
      border: 1px solid rgba(255, 255, 255, 0.1);
    }

    #search {
      margin: 10px;
      padding: 8px 12px;
      border-radius: 12px;
      border: none;
      background-color: rgba(20, 20, 20, 0.35);
      color: @foreground;
      font-size: 16px;
    }

    #list {
      margin: 5px;
    }

    #item {
      padding: 8px;
      margin: 4px;
      border-radius: 12px;
      color: white;
      font-size: 15px;
      font-weight: 500;
    }

    #item:selected {
      background-color: rgba(20, 20, 20, 0);
      border: 2px solid @color7;
    }
  '';
}
