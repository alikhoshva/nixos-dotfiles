{ pkgs, pkgs-unstable, ... }:

{
  programs.zen-browser.enable = true;
  programs.zen-browser.policies = {
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
    Preferences = {
      "widget.wayland.fractional-scale.enabled" = false;
      "layout.css.devPixelsPerPx" = "1.5";
      "network.dns.disablePrefetch" = false;
      "accessibility.force_disabled" = 1;
    };
  };
}
