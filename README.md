# My nix configuration

This is a nix flake defining my system and user configurations. It is currently work in progress and very incomplete.

## Initial bootstrap

If the experimental feature `nix-command` and `flakes` not enabled, run `nix-shell` from this directory to enable them.

Run `nixos-rebuild --flake .#matts-laptop` to install the system configuration.

Run `home-manager --flake .#matt` to install the user configuration.

## Updating

TODO

## TODO

- Move modules to `modules` directory
- Use module options to enable & configure modules
- Define config and which modules are used in a host config file, instead of in `flake.nix`
