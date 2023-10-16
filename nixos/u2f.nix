{
  config,
  pkgs,
  ...
}: {
  # Enable Universal 2nd Factor (Yubikey)
  hardware.u2f.enable = true;

  # This should be implied
  #udev.packages = [ pkgs.libu2f-host ];

  # Allow u2f to be used for login/sudo
  # Add a key to `~/.config/Yubico/u2f_keys`
  # to trust a Yubikey:
  # nix-shell -p pam_u2f pamu2fcfg >> ~/.config/Yubico/u2f_keys
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
}
