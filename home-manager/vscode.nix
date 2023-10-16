{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    userSettings = {
      # UI
      "window.titleBarStyle" = "custom"; # native or custom
      "window.menuBarVisibility" = "toggle"; # Hidden until hitting <Alt>
      "workbench.sideBar.location" = "right";
      "workbench.editor.closeOnFileDelete" = true;
      "workbench.editor.enablePreview" = false;
      "workbench.editor.untitled.hint" = "hidden";
      "workbench.iconTheme" = "vs-minimal";
      "workbench.startupEditor" = "none";
      "workbench.statusBar.visible" = true;
      "workbench.tips.enabled" = false;
      "workbench.welcomePage.walkthroughs.openOnInstall" = false;
      "window.zoomLevel" = -1; # Make everything more compact

      "telemetry.telemetryLevel" = "off";

      # Theme & font
      "workbench.colorTheme" = "Catppuccin Mocha";
      "editor.fontFamily" = "'JetBrains Mono', 'Symbols Nerd Font', 'Noto Color Emoji'";
      "editor.fontSize" = 14;
      "editor.fontLigatures" = true;

      # Terminal
      "terminal.external.linuxExec" = "kitty";
      "terminal.integrated.defaultProfile.linux" = "fish";
      "terminal.integrated.gpuAcceleration" = "on";

      # Vim
      "vim.leader" = " ";
      "editor.cursorSurroundingLines" = 8; # scrolloff
      "vim.smartRelativeLine" = true;
      "vim.hlsearch" = true;
      "vim.highlightedyank.enable" = true;

      "vim.insertModeKeyBindings" = [
        {
          # jj to quickly exit insert mode
          before = ["j" "j"];
          after = ["<Esc>"];
        }
      ];

      "vim.normalModeKeyBindings" = [
        {
          # Shift-K to show "hover" documentation
          before = ["K"];
          after = ["g" "h"];
        }
        {
          before = ["g" "i"];
          commands = ["editor.action.goToImplementation"];
        }
      ];
    };

    extensions = with pkgs.vscode-extensions; [
      # General
      catppuccin.catppuccin-vsc
      vscodevim.vim
      github.codespaces # Using codespaces for CS50
      usernamehw.errorlens # Inline error messages

      # Languages
      bbenoist.nix # Nix language support
      ms-vscode.cpptools # C & C++ Support
      ms-python.python # Python support
      bmalehorn.vscode-fish # Fish support
      waderyan.gitblame # Show blame info
      davidanson.vscode-markdownlint # Markdown language support (preview is already builtin to vscode)
      bierner.emojisense # 😄 emoji completion
      bierner.markdown-emoji # Support :emoji: syntax in markdown

      # Java
      redhat.java # Language support
      vscjava.vscode-java-debug # Debugging support
      vscjava.vscode-java-test # Run/debug tests
      vscjava.vscode-java-dependency # Manage Java projects
      vscjava.vscode-gradle # Gradle tasks/UI
    ];
  };
}
