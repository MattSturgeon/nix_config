{
  config,
  pkgs,
  ...
}: {
  programs.fish.enable = true;
  environment.shells = with pkgs; [fish];

  users.defaultUserShell = pkgs.bash;

  # TODO move to user config
  users.users.matt.shell = pkgs.fish;
}
