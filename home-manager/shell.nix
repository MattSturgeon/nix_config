{
  config,
  pkgs,
  ...
}: {
  # home-manager needs to manage bash in order for sessionVariables
  # to be added to ~/.profile
  programs.bash.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable the greeting
    '';
  };
}
