{
  config,
  pkgs,
  ...
}: {
  # Enable rootless docker
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
}
