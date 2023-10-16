{
  config,
  pkgs,
  ...
}: {
  config = {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      # "Code" fonts
      fira-code
      jetbrains-mono
      intel-one-mono

      # Nerd Font Symbols (Powerline, FontAwesome, MaterialIcons, etc)
      # https://www.nerdfonts.com/#features
      #  
      (nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})

      # Emoji font 😀🙋🌟🎉
      noto-fonts-emoji
    ];
  };
}
