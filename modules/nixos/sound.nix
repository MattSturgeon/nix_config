{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.custom.sound;
in
{
  options.custom.sound = {
    jack = mkEnableOption "Enable Jack";
  };

  config = {
    # pipewire and pulseaudio conflict
    hardware.pulseaudio.enable = false;

    # nixos.wiki recomends using rtkit with pipewire
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = cfg.jack;
      wireplumber.configPackages = [
        (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" /* lua */ ''
          bluez_monitor.properties = {
              ["bluez5.enable-sbc-xq"] = true,
              ["bluez5.enable-msbc"] = true,
              ["bluez5.enable-hw-volume"] = true,
              ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
          }
        '')
      ];
    };
  };
}
