{
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

{
  home.packages = with pkgs; [
    nixfmt
    nixd
    ruff
  ];

  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
    mutableExtensionsDir = false;
    profiles.default = {
      extensions = with pkgs-unstable.vscode-extensions; [
        # --- Themes & Icons ---
        pkief.material-icon-theme

        # --- Nix Essentials ---
        jnoortheen.nix-ide

        # --- Web Development ---
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
        bradlc.vscode-tailwindcss

        # --- General Productivity ---
        usernamehw.errorlens
        christian-kohler.path-intellisense
        ms-azuretools.vscode-docker
        ms-toolsai.jupyter
        ms-python.python
        ms-vscode.cpptools
        ms-vscode-remote.remote-containers
        #Google.gemini-cli-vscode-ide-companion
        google.colab
        asvetliakov.vscode-neovim

        #arrterian.nix-env-selector
        mikestead.dotenv
        mkhl.direnv
        charliermarsh.ruff
        ms-python.vscode-pylance

        james-yu.latex-workshop
      ];

      # --- Neovim Keybindings in VSCode ---
      keybindings = [
        # Split Navigation (Geometrical)
        {
          key = "ctrl+h";
          command = "workbench.action.focusLeftGroup";
          when = "editorTextFocus && vim.active && vim.mode != 'Insert'";
        }
        {
          key = "ctrl+l";
          command = "workbench.action.focusRightGroup";
          when = "editorTextFocus && vim.active && vim.mode != 'Insert'";
        }
        {
          key = "ctrl+k";
          command = "workbench.action.focusAboveGroup";
          when = "editorTextFocus && vim.active && vim.mode != 'Insert'";
        }
        {
          key = "ctrl+j";
          command = "workbench.action.focusBelowGroup";
          when = "editorTextFocus && vim.active && vim.mode != 'Insert'";
        }

        # --- Autocomplete Navigation (Vim Style) ---
        {
          key = "tab";
          command = "selectNextSuggestion";
          when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
        }
        {
          key = "shift+tab";
          command = "selectPrevSuggestion";
          when = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
        }
        {
          key = "ctrl+y";
          command = "acceptSelectedSuggestion";
          when = "suggestWidgetVisible && textInputFocus";
        }
      ];

      userSettings = {
        "password-store" = "gnome-libsecret";
        "window.titleBarStyle" = "custom";
        "window.menuBarVisibility" = "classic";
        "window.menuStyle" = "custom";
        "window.dialogStyle" = "custom";
        "window.customTitleBarVisibility" = "never";
        "workbench.layoutControl.enabled" = false;
        # --- General Settings ---
        "workbench.sideBar.location" = "right";
        "git.confirmSync" = false;
        "update.mode" = "none";
        "editor.inlineSuggest.enabled" = false;
        "files.insertFinalNewline" = true;

        # --- Python Integration ---
        "ruff.path" = [ "${pkgs.ruff}/bin/ruff" ];

        # --- Neovim Flake Integration ---
        "vscode-neovim.neovimExecutablePaths.linux" = "${
          inputs.nvim-config.packages.${pkgs.stdenv.hostPlatform.system}.default
        }/bin/nvim";
        "vscode-neovim.neovimInitVimPaths.linux" = "";

        # --- Theme and Aesthetics ---
        "workbench.colorTheme" = "Dark Modern";
        "workbench.iconTheme" = "material-icon-theme";

        # --- Typography ---
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'JetBrainsMono NF', 'monospace', monospace";
        "editor.fontSize" = 14;
        "editor.fontLigatures" = true;
        "editor.lineHeight" = 1.6;
        "editor.letterSpacing" = 0.5;

        # --- Neovim-like UI and Visuals ---
        "editor.lineNumbers" = "relative";
        "editor.minimap.enabled" = false;
        #"editor.rulers" = [ 80 120 ];
        "breadcrumbs.enabled" = false;
        #"workbench.activityBar.location" = "hidden";
        "editor.cursorBlinking" = "solid";
        "editor.cursorStyle" = "block";

        # Prevent native VSCode from messing up Vim completion flow
        "editor.acceptSuggestionOnEnter" = "off";
        "editor.tabCompletion" = "off";

        # --- Extension Performance Adjustments ---
        "extensions.experimental.affinity" = {
          "asvetliakov.vscode-neovim" = 1;
        };

        # --- Nix Language Server Settings ---
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd";
        "nix.serverSettings" = {
          "nixd" = {
            "formatting" = {
              "command" = [ "nixfmt" ];
            };
          };
        };

        # --- Language-Specific Settings ---
        "[css]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.formatOnSave" = true;
        };
        "[json]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.formatOnSave" = true;
        };
        "[jsonc]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.formatOnSave" = true;
        };
        "[nix]" = {
          "editor.defaultFormatter" = "jnoortheen.nix-ide";
          "editor.formatOnSave" = true;
        };
      };
    };
  };
}
