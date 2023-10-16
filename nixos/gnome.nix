{
  config,
  lib,
  pkgs,
  ...
}: {
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;

    excludePackages = with pkgs; [
      xterm
    ];
  };

  environment.systemPackages =
    (with pkgs.gnome; ([
        # Manually curate core-utilities:
        #baobab
        #cheese
        #eog
        #epiphany
        pkgs.gnome-text-editor
        gnome-calculator
        gnome-calendar
        gnome-characters
        gnome-clocks
        #pkgs.gnome-console
        #gnome-contacts
        gnome-font-viewer
        gnome-logs
        #gnome-maps
        #gnome-music
        #pkgs.gnome-photos
        gnome-system-monitor
        #gnome-weather
        nautilus
        pkgs.gnome-connections
        simple-scan
        totem
        #yelp

        # Additional packages not included in core-utilities:
        pkgs.nautilus-open-any-terminal
        file-roller
      ]
      ++ lib.optionals config.services.flatpak.enable [
        # Since PackageKit Nix support is not there yet,
        # only install gnome-software if flatpak is enabled.
        gnome-software
      ]))
    ++ (with pkgs.gnomeExtensions; [
      # Install some extensions too:
      appindicator
      dash-to-dock
    ]);

  services = {
    # Disable core-utilities so we can install packages explicitly above
    gnome.core-utilities.enable = false;

    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
    ];
  };

  services.pipewire.enable = true;
  xdg.portal.enable = true;
}
