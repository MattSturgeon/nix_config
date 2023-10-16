{
  config,
  pkgs,
  ...
}: {
  # FIXME define user info in a central location
  home.username = "matt";
  home.homeDirectory = "/home/matt";

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };

  # Reload system services when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
