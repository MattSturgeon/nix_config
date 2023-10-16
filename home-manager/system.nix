{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    tree
    wl-clipboard # Manage clipboard from the CLI
  ];
}
