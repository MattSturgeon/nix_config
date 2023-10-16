{
  config,
  pkgs,
  ...
}: {
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
      };

      maps = {
        # Quick exit insert mode using `jj`
        insert."jj" = {
          action = "<Esc>";
          silent = true;
        };

        # Better up/down movement
        normalVisualOp."j" = {
          action = "v:count == 0 ? 'gj' : 'j'";
          expr = true;
          silent = true;
        };
        normalVisualOp."k" = {
          action = "v:count == 0 ? 'gk' : 'k'";
          expr = true;
          silent = true;
        };

        # Better window motions
        normal."<C-h>" = {
          action = "<C-w>h";
          desc = "Go to left window";
        };
        normal."<C-j>" = {
          action = "<C-w>j";
          desc = "Go to lower window";
        };
        normal."<C-k>" = {
          action = "<C-w>k";
          desc = "Go to upper window";
        };
        normal."<C-l>" = {
          action = "<C-w>l";
          desc = "Go to right window";
        };
      };
      plugins = {
        bufferline.enable = true;
        fugitive.enable = true;
        lualine.enable = true;
        comment-nvim.enable = true;
        todo-comments.enable = true;
        which-key.enable = true;

        gitsigns = {
          enable = true;
          # The right alighed virtext was getting annoying; when the window is small it can clobber actual text!
          # Disable git blame for now
          currentLineBlame = false;
          # currentLineBlameOpts.virtTextPos = "right_align";
        };

        indent-blankline = {
          enable = true;
          charList = ["¦"];
          charListBlankline = ["↵"];
          useTreesitter = true;
        };

        mini = {
          enable = true;
          modules = {
            bracketed = {}; # Jump to various targets with []
            pairs = {}; # ~ autopairs
            surround = {}; # ~ surround
            trailspace = {}; # Highlight/remove trailing whitespace
          };
        };

        telescope = {
          enable = true;
          extensions = {
            frecency.enable = true;
            fzf-native.enable = true;
            media_files.enable = true;
          };
        };

        treesitter = {
          enable = true;
          indent = true;
          nixvimInjections = true; # Highlight lua in NixVim config
        };
        treesitter-context.enable = true; # Prevent context from scrolling off screen (e.g. function declaration)

        nvim-cmp = {
          enable = true;
          mapping = {
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "C-y" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = {
              modes = ["i" "s"];
              action = ''
                function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif luasnip.expandable() then
                    luasnip.expand()
                  elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                  elseif has_words_before() then
                    fallback()
                  else
                    fallback()
                  end
                end
              '';
            };
            "<S-Tab>" = {
              modes = ["i" "s"];
              action = ''
                            function(fallback)
                if cmp.visible() then
                                cmp.select_prev_item()
                              elseif luasnip.jumpable(-1) then
                                luasnip.jump(-1)
                              else
                                fallback()
                              end
                            end
              '';
            };
          };

          # Setting this means we don't need to explicitly enable
          # each completion source, so long as the plugin is listed
          # in https://github.com/pta2002/nixvim/blob/794356625c19e881b4eae3bbbb078f3299f5c81d/plugins/completion/nvim-cmp/cmp-helpers.nix#L22
          autoEnableSources = true;
          sources = [
            {
              name = "buffer";
              groupIndex = 4;
            }
            {
              name = "nvim_lsp";
              groupIndex = 2;
            }
            {
              name = "luasnip";
              groupIndex = 3;
            }
            {
              name = "treesitter";
              groupIndex = 2;
            }
            # { name = "dap"; groupIndex = 1; }
            # { name = "copilot"; groupIndex = 1; }
            {
              name = "git";
              groupIndex = 1;
            }
            {
              name = "conventionalcommits";
              groupIndex = 1;
            }
            {
              name = "spell";
              groupIndex = 2;
            }
            {
              name = "emoji";
              groupIndex = 1;
            }
          ];
        };

        luasnip.enable = true; # TODO install snippets

        lsp = {
          enable = true;
          # Bind keys to `vim.lsp.buf.*` functions:
          keymaps.lspBuf = {
            K = "hover";
            gD = "references";
            gd = "definition";
            gi = "implementation";
            gt = "type_definition";
          };
          servers = {
            bashls.enable = true;
            html.enable = true;
            java-language-server.enable = true;
            lua-ls.enable = true;
            nil_ls.enable = true; # Nix LS
            ccls.enable = true; # C/C++/ObjC LS
            #cangd.enable = true; # LLVM C/C++ LS
            rust-analyzer.enable = true;
            gopls.enable = true; # Golang LS
            tsserver.enable = true; # TypeScript & JavaScript
            zls.enable = true; # Zig
          };
        };

        lsp-lines.enable = true;
      };

      extraPlugins = with pkgs.vimPlugins; [
        vim-be-good
      ];

      extraConfigLuaPre = ''
               -- Define some variables used in nvim-cmp keybinds
        -- as per the example on nvim-cmp's wiki
        local has_words_before = function()
                 unpack = unpack or table.unpack
                 local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                 return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
               end

               local luasnip = require("luasnip")
               local cmp = require("cmp")
      '';
    };
  };
}
