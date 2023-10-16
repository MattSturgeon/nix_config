{
  config,
  pkg,
  ...
}: {
  options = {};

  config = {
    programs.zellij = {
      enable = true;
      settings = {
        copy_command = "wl-copy";
      };
    };
  };
}
