{ pkgs, ... }: {
  # Enable fonts
  fonts.packages = with pkgs; [
    fira-sans
    font-awesome
    roboto
    # It's also a good idea to have a fallback for emojis and other symbols
    noto-fonts-cjk-sans
    noto-fonts-color-emoji

    nerd-fonts.code-new-roman
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu
  ];
}
