{
  # Enable the gnome-keyring secrets daemon
  services.gnome.gnome-keyring.enable = true;

  # Ensure PAM unlocks the keyring automatically on login (for TTY and greetd)
  security.pam.services.login.enableGnomeKeyring = true;

  # Enable the modern GCR-based SSH agent
  services.gnome.gcr-ssh-agent.enable = true;
}
