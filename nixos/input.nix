{
  config,
  pkgs,
  ...
}: {
  services.xserver.libinput = {
    enable = true;
    mouse = {
      accelProfile = "adaptive";
      accelSpeed = "+0.5";
    }; # TODO
    touchpad = {
      clickMethod = "clickfinger";
      tapping = true;
      scrollMethod = "twofinger";
      horizontalScrolling = true;
      naturalScrolling = false;
      disableWhileTyping = true;
      accelProfile = "adaptive";
      accelSpeed = "+0.5";
    };
  };
}
