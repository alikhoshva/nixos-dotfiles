{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";

    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      ExtensionSettings = {
        # uBlock Origin
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        # Bitwarden Password Manager
        "{446900e4-71c2-4960-a805-547796d1680f}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
        };
        # Sidebery (Vertical Tabs & Workspaces)
        "{3c078156-979c-498b-8990-85f7987dd929}" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
        };
      };
    };

    profiles.aleks = {
      isDefault = true;
      settings = {
        "sidebar.verticalTabs" = true;
        "sidebar.revamp" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.aboutConfig.showWarning" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "dom.security.https_only_mode" = true;
        "identity.fxaccounts.enabled" = false;
      };

      userChrome = ''
        /* Hide horizontal tab bar when using vertical tabs */
        #TabsToolbar {
          visibility: collapse !important;
        }
        /* Hide sidebar header title for cleaner look */
        #sidebar-header {
          display: none !important;
        }
      '';
    };
  };
}
