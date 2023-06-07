
{ config, pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  programs.hyprland.enable = true;
}