{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.me.nixgl;
  nonNixOS = config.me.otherHost;
  nixGL = config.me.nixgl.glWrapper;
  nixVulkan = config.me.nixgl.vulkanWrapper;
in {
  options.me.otherHost = mkEnableOption "Enable options that make things work better on non-NixOS hosts";
  options.me.nixgl = {
    enable = mkEnableOption "Use nixGL wrapper";
    glWrapper = mkOption {
      type = types.package;
      default = pkgs.nixgl.nixGLIntel;
      defaultText = literalExpression "pkgs.nixgl.nixGLIntel";
      description = "OpenGL wrapper package to use.";
    };
    vulkanWrapper = mkOption {
      type = types.package;
      default = pkgs.nixgl.nixVulkanIntel;
      defaultText = literalExpression "pkgs.nixgl.nixVulkanIntel";
      description = "Vulkan wrapper package to use.";
    };
    glPackages = mkOption {
      # Can't do listOf packages because we need to overlay them
      type = types.listOf types.str;
      default = [];
      defaultText = literalExpression "[]";
      description = "Packages to wrap with the OpenGL wrapper";
    };
    vulkanPackages = mkOption {
      type = types.listOf types.str;
      default = [];
      defaultText = literalExpression "[]";
      description = "Packages to wrap with the Vulkan wrapper";
    };
  };

  # Enable settings that make nix/hm work better on _other_ distros
  targets.genericLinux.enable = nonNixOS;

  config = mkIf cfg.enable {
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
      (final: prev: let
        getPkg = name: prev.${name};
        # TODO
      in {
        kitty = wrap prev.kitty nixGL;
      })
    ];
  };
}
