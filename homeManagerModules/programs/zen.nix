{ pkgs, ... }:

{
  programs.zen-browser.enable = true;
  programs.zen-browser.policies = {
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
      "accessibility.force_disabled" = 1;
      "gfx.webrender.all" = true;
      "media.ffmpeg.vaapi.enabled" = true;
    };
  };
}
