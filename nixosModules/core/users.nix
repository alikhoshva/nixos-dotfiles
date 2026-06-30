{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.aleks = {
    isNormalUser = true;
    description = "Aleks Likhoshva";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
