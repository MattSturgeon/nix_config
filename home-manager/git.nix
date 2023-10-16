{
  config,
  pkgs,
  ...
}: {
  programs = {
    # Git
    git = {
      enable = true;
      userName = "Matt Sturgeon";
      userEmail = "matt@sturgeon.me.uk";
      signing = {
        key = "ED1A8299";
        signByDefault = true;
      };
      extraConfig = {
        init.defaultBranch = "main";
      };
      delta.enable = true;
    };
    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };
  };
}
