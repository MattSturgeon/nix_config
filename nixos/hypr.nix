{
  config,
  pkgs,
  ...
}: {
  services.xserver.enable = true;
  programs.hyprland.enable = true;
}
