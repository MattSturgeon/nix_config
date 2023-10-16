{
  config,
  pkgs,
  ...
}: {
  programs.starship = {
    enable = true;
    enableTransience = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    # See https://starship.rs/config
    settings = {
      add_newline = true;
      character = {
        success_symbol = "➜(bold green)";
        error_symbol = "➜(bold red)";
      };
    };
  };

  programs.fish.functions = {
    starship_transient_prompt_func = ''
      if fish_is_root_user
          echo '# '
      else
          echo '$ '
      end
    '';
  };
}
