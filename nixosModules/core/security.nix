{
  security.polkit.enable = true;

  services.gnome = {
    gnome-keyring.enable = true;
    gcr-ssh-agent.enable = true;
  };

  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;
    hyprlock.enableGnomeKeyring = true;
  };

  programs.seahorse.enable = true;
}


