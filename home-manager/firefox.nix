{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  browser = config.me.browser;
in {
  # TODO move this somewhere common to multiple browsers
  # TODO restructure to allow installing multiple browsers?
  options.me.browser = mkOption {
    type = types.str;
    default = "firefox";
  };

  config = mkIf (browser == "firefox") {
    programs = {
      firefox = {
        enable = true;
        package = pkgs.firefox-wayland;
        profiles.matt = {
          id = 0;
          name = "Matt Sturgeon";
          isDefault = true;
          search = {
            default = "google"; # TODO Move to something more privacy respecting?
            force = true; # Firefox often replaces the symlink, so force on update
          };
          # extensions = [ ]; # (some are packaged in NUR)
          # extraConfig = '' ''; # user.js
          # userChrome = '' ''; # chrome CSS
          # userContent = '' ''; # content CSS
        };
      };
    };

    home.packages = with pkgs; [
      fx_cast_bridge
    ];

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = 1;
    };
  };
}
