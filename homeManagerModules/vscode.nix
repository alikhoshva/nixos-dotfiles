{ pkgs, pkgs-unstable, ... }:

{
  home.packages = with pkgs; [ nixfmt nil ];

  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
    profiles.default = {
      extensions = with pkgs-unstable.vscode-extensions; [
        # --- Nix Essentials ---
        jnoortheen.nix-ide

        # --- Web Development ---
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
        bradlc.vscode-tailwindcss

        # --- General Productivity ---
        usernamehw.errorlens
        christian-kohler.path-intellisense
        ms-azuretools.vscode-containers
        ms-toolsai.jupyter
        ms-python.python
        ms-vscode.cpptools
        ms-vscode-remote.remote-containers
        Google.gemini-cli-vscode-ide-companion
        google.colab
        asvetliakov.vscode-neovim

        arrterian.nix-env-selector
        mikestead.dotenv
        mkhl.direnv
        ms-python.black-formatter
        ms-python.vscode-pylance
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
          when =
            "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
        }
        {
          key = "shift+tab";
          command = "selectPrevSuggestion";
          when =
            "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
        }
        {
          key = "ctrl+y";
          command = "acceptSelectedSuggestion";
          when = "suggestWidgetVisible && textInputFocus";
        }
      ];

      userSettings = {
        # --- General Settings ---
        "workbench.sideBar.location" = "right";
        "git.confirmSync" = false;
        "update.mode" = "none";
        "python.analysis.extraPaths" = [ ".venv\\Lib\\site-packages" ];
        "editor.inlineSuggest.enabled" = false;
        "files.insertFinalNewline" = true;

        # --- Neovim Flake Integration ---
        "vscode-neovim.neovimExecutablePaths.linux" =
          "/etc/profiles/per-user/aleks/bin/nvim";
        "vscode-neovim.neovimInitVimPaths.linux" = "";

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
        "nix.serverPath" = "nil";
        "nix.serverSettings" = {
          "nil" = { "formatting" = { "command" = [ "nixfmt" ]; }; };
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
        "[nix]" = { "editor.formatOnSave" = true; };
      };
    };
  };
}
