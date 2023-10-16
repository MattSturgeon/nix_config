{
  config,
  pkgs,
  ...
}: {
  services.printing = {
    enable = true;
    #drivers = with pkgs; [ hplip ];
  };

  # Enable zero-config network printing
  services.avahi = {
    enable = true;
    nssmdns = true;
    # for a WiFi printer
    openFirewall = true;
  };
}
