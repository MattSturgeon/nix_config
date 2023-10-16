{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  boot = {
    plymouth = {
      enable = true;
      theme = "breeze";
    };
    kernelParams = ["quiet"];
    initrd.systemd.enable = true;
  };
}
