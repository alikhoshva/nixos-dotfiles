{
  # Enable Polkit for authentication & privilege elevation (e.g. gparted, pkexec)
  security.polkit.enable = true;

  # Enable the gnome-keyring secrets daemon
  services.gnome.gnome-keyring.enable = true;

  # Ensure PAM unlocks the keyring automatically for greetd
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Enable the modern GCR-based SSH agent
  services.gnome.gcr-ssh-agent.enable = true;
}

