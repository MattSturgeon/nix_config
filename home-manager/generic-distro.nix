{
  config,
  pkgs,
  ...
}: let
  # Define which nixGL packages to usu
  # TODO get this from config so that it can be different on Nvidia hosts
  nixGL = pkgs.nixgl.nixGLIntel;
  nixVulkan = pkgs.nixgl.nixVulkanIntel;
in {
  # Enable settings that make nix/hm work better on _other_ distros
  targets.genericLinux.enable = true;

  # Install nixGL to run gfx programs like kitty
  home.packages = [nixGL nixVulkan];

  # Overlay nix packages with wrapped versions
  nixpkgs.overlays = let
    wrap = pkg: wrapper: let
      exe = pkgs.lib.getExe pkg;
      wrapperExe = pkgs.lib.getExe wrapper;
      wrapped = pkgs.writeShellScriptBin (builtins.baseNameOf exe) ''
        exec -a "$0" ${wrapperExe} ${exe} "$@"
      '';
    in
      pkgs.symlinkJoin {
        name = pkg.pname;
        paths = [wrapped pkg];
      };
  in [
    (final: prev: {
      kitty = wrap prev.kitty nixGL;
    })
  ];
}
