{ config
, lib
, pkgs
, nixvim
, ...
}:
let
  inherit (lib) types mkOption mkIf;
  cfg = config.custom.editors;
in
{
  imports = [ nixvim.homeManagerModules.nixvim ];

  options.custom.editors.nvim = mkOption {
    type = types.bool;
    default = true;
    description = "Use Neovim";
  };

  config = mkIf cfg.nvim {
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    programs = {
      nixvim = {
        enable = true;
        viAlias = true;
        vimAlias = true;

        colorschemes.catppuccin = {
          enable = true;
          background.light = "macchiato";
          background.dark = "mocha";
        };

        luaLoader.enable = true;
        editorconfig.enable = true;
        clipboard.providers.wl-copy.enable = true;

        globals = {
          mapleader = " ";
        };

        options = {
          number = true; # Line numbers
          relativenumber = true; # ^Relative
          shiftwidth = 4; # Tab width
          smartindent = true;
          cursorline = true; # Highlight the current line
          scrolloff = 8; # Ensure there's at least 8 lines around the cursor
          title = true; # Let vim set the window title
          spell = true; # Enable spellcheck
          conceallevel = 2; # Enable syn-cchar replacements (for Obsidian)
        };

        keymaps = [
          {
            # Quick exit insert mode using `jj`
            mode = "i";
            key = "jj";
            action = "<Esc>";
            options.silent = true;
          }

          # Show which-key
          {
            mode = [ "n" "v" ];
            key = "<C-Space>";
            action = "<cmd>WhichKey<CR>";
            options.silent = true;
            options.desc = "Which Key";
          }

          # Window motions
          {
            mode = "n";
            key = "<leader>w";
            # Workaround which-key.nvim issue #583
            # Call :WhichKey manually, delegating <C-w>
            action = "<cmd>WhichKey <C-w><CR>";
            options.silent = true;
            options.desc = "+windows";
          }

          # Buffer motions
          {
            mode = "n";
            key = "<leader>bn";
            action = "<cmd>bn<CR>";
            options.silent = true;
            options.desc = "Go to next buffer";
          }
          {
            mode = "n";
            key = "<leader>bp";
            action = "<cmd>bp<CR>";
            options.silent = true;
            options.desc = "Go to previous buffer";
          }

          # Refactoring
          {
            mode = "n";
            key = "<leader>rr";
            action = /* lua */ ''
              function() require("telescope").extensions.refactoring.refactors() end
            '';
            lua = true;
            options.desc = "Select refactor";
          }
          {
            mode = "n";
            key = "<leader>re";
            action = "<cmd>Refactor extract_var ";
            options.desc = "Extract to variable";
          }
          {
            mode = "n";
            key = "<leader>rE";
            action = "<cmd>Refactor extract ";
            options.desc = "Extract to function";
          }
          {
            mode = "n";
            key = "<leader>rb";
            action = "<cmd>Refactor extract_block ";
            options.desc = "Extract to block";
          }
          {
            mode = "n";
            key = "<leader>ri";
            action = "<cmd>Refactor inline_var ";
            options.desc = "Inline variable";
          }
          {
            mode = "n";
            key = "<leader>rI";
            action = "<cmd>Refactor inline_func ";
            options.desc = "Inline function";
          }
        ];

        autoCmd = [
          {
            desc = "Highlight on yank";
            event = "TextYankPost";
            callback.__raw = /* lua */ ''
              function() vim.highlight.on_yank({ higroup="IncSearch", timeout=250 }) end
            '';
          }
        ];

        plugins = {
          fugitive.enable = true;
          lualine.enable = true;
          comment-nvim.enable = true;
          todo-comments.enable = true;
          refactoring.enable = true;

          which-key = {
            enable = true;
            registrations = {
              # Group names
              "<leader>b" = "+buffers";
              "<leader>r" = "+refactoring";
            };
          };

          gitsigns = {
            enable = true;
            # The right alighed virtext was getting annoying; when the window is small it can clobber actual text!
            # Disable git blame for now
            currentLineBlame = false;
            # currentLineBlameOpts.virtTextPos = "right_align";
          };

          indent-blankline = {
            enable = true;
            indent.char = "¦";
          };

          mini = {
            enable = true;
            modules = {
              surround = { }; # ~ surround
              trailspace = { }; # Highlight/remove trailing whitespace
            };
          };

          nvim-autopairs.enable = true;

          telescope = {
            enable = true;
            extensions = {
              frecency.enable = true;
              fzf-native.enable = true;
              media_files.enable = true;
            };
            keymaps = {
              "<leader>bb" = {
                action = "buffers";
                desc = "List buffers";
              };
            };
          };

          treesitter = {
            enable = true;
            indent = true;
          };
          treesitter-context = {
            enable = true;
            maxLines = 4;
            minWindowHeight = 40;
          };

          cmp = {
            enable = true;

            # Setting this means we don't need to explicitly enable
            # each completion source, so long as the plugin is listed
            # in https://github.com/nix-community/nixvim/blob/cd32dcd50fa98cd03e2916b6fd47e31deffbca24/plugins/completion/cmp/cmp-helpers.nix#L23
            autoEnableSources = true;

            settings = {
              mapping.__raw = /* lua */ ''
                cmp.mapping.preset.insert({
                  ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Use first if none selected
                  ["<C-CR>"] = cmp.mapping.confirm({ select = true }), -- C-y alias
                  ["<CR>"] = cmp.mapping.confirm(), -- Return can confirm if selected
                  ["<C-Space>"] = cmp.mapping.complete(), -- Open list without typing
                })
              '';

              sources = [
                {
                  name = "emoji";
                  groupIndex = 1;
                }
                {
                  name = "nvim_lsp";
                  groupIndex = 2;
                }
                {
                  name = "treesitter";
                  groupIndex = 2;
                }
                {
                  name = "spell";
                  groupIndex = 2;
                }
                {
                  name = "luasnip";
                  groupIndex = 3;
                }
              ];
            };

            filetype = {
              gitcommit = {
                sources = [
                  { name = "conventionalcommits"; }
                  { name = "git"; }
                  { name = "emoji"; }
                  { name = "path"; }
                ];
              };
            };

            cmdline =
              let
                common = {
                  mapping.__raw = /* lua */ ''
                    cmp.mapping.preset.cmdline({
                      ["<C-Space>"] = cmp.mapping.complete(), -- Open list without typing
                    })
                  '';
                  sources = [{ name = "buffer"; }];
                };
              in
              {
                "/" = common;
                "?" = common;
                ":" = {
                  inherit (common) mapping;
                  sources = [
                    { name = "path"; }
                    { name = "cmdline"; }
                  ];
                };
              };
          };

          luasnip.enable = true; # TODO install snippets

          lsp = {
            enable = true;

            # LSP keybinds (see :h lsp-buf):
            keymaps.lspBuf = {
              K = {
                action = "hover";
                desc = "Show documentation";
              };
              gd = {
                action = "definition";
                desc = "Goto definition";
              };
              gD = {
                action = "declaration";
                desc = "Goto declaration";
              };
              gi = {
                action = "implementation";
                desc = "Goto implementation";
              };
              gr = {
                action = "references";
                desc = "Show references";
              };
              gt = {
                # FIXME conflicts with "next tab page" :h gt
                action = "type_definition";
                desc = "Goto type definition";
              };
              ga = {
                action = "code_action";
                desc = "Show code actions";
              };
              "g*" = {
                action = "document_symbol";
                desc = "Show document symbols";
              };
              "<leader>rn" = {
                action = "rename";
                desc = "Rename symbol";
              };
            };

            servers = {
              bashls.enable = true;
              html.enable = true;
              java-language-server.enable = true;
              lua-ls.enable = true;
              nil_ls.enable = true; # Nix LS
              ccls.enable = true; # C/C++/ObjC LS
              #cangd.enable = true; # LLVM C/C++ LS
              gopls.enable = true; # Golang LS
              tsserver.enable = true; # TypeScript & JavaScript
              zls.enable = true; # Zig
              rust-analyzer = {
                enable = true;
                installCargo = true;
                installRustc = true;
              };
            };
          };

          lsp-lines = {
            enable = true;
            currentLine = true;
          };
        };

        extraPlugins = with pkgs.vimPlugins; [
          vim-be-good # vim motions minigames
          vim-sleuth # tpope's indent fixes
        ];

        extraConfigLuaPre = /* lua */ ''
          -- load refactoring.nvim Telescope extension
          require("telescope").load_extension("refactoring")
        '';
      };
    };
  };
}
