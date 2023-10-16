{
  config,
  pkg,
  ...
}: {
  programs.zellij = {
    enable = true;
    settings = {
      copy_command = "wl-copy";
    };
  };
}
