{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withRuby = true;

    extraPackages = with pkgs; [
      # TS/JS
      nodePackages.prettier

      # Rust
      rust-analyzer
      rustfmt

      # Nix
      alejandra

      # Python
      black

      # Lua
      stylua
      lua-language-server

      # Misc
      codespell
      ripgrep
      yazi
      fd
    ];

    luaLoader.enable = true;
    performance = {
      combinePlugins.enable = true;
      byteCompileLua.enable = true;
    };

    colorschemes.rose-pine.enable = true;

    opts = {
      laststatus = 3;
      relativenumber = true;
      number = true;
    };

    globals = {
      mapleader = " ";
    };

    extraConfigLua = ''
      require("telescope").load_extension("yank_history")
    '';

    keymaps = [
      {
        # Unmap space (leader)
        action = "<nop>";
        key = "<Leader>";
        options = {
          noremap = true;
          silent = true;
        };
        mode = "n";
      }
      {
        action = "<cmd>sp<CR><C-w>j";
        key = "<Leader>-";
        options.silent = true;
        options.desc = "Split window horizontally";
      }
      {
        action = "<cmd>vsp<CR><c-w>l";
        key = "<Leader>\\";
        options.silent = true;
        options.desc = "Split window vertically";
      }
      {
        action = "<cmd>ZenMode<CR>";
        key = "<Space>wz";
        options = {
          silent = true;
          noremap = true;
          desc = "Zen mode";
        };
      }
      {
        action = "<C-w>h";
        key = "<C-h>";
        options = {
          silent = true;
          noremap = true;
          desc = "Move to left window";
        };
      }
      {
        action = "<C-w>j";
        key = "<C-j>";
        options = {
          silent = true;
          noremap = true;
          desc = "Move to lower window";
        };
      }
      {
        action = "<C-w>k";
        key = "<C-k>";
        options = {
          silent = true;
          noremap = true;
          desc = "Move to upper window";
        };
      }
      {
        action = "<C-w>l";
        key = "<C-l>";
        options = {
          silent = true;
          noremap = true;
          desc = "Move to right window";
        };
      }
      {
        action = "<cmd>close<CR>";
        key = "<Leader>wd";
        options = {
          silent = true;
          noremap = true;
          desc = "Close current window";
        };
      }
      {
        action = "<cmd>Telescope find_files<CR>";
        key = "<Leader>ff";
        options = {
          silent = true;
          noremap = true;
          desc = "Find files";
        };
      }
      {
        action = "<cmd>Telescope live_grep<CR>";
        key = "<Leader>/";
        options = {
          silent = true;
          noremap = true;
          desc = "Live grep";
        };
      }
      {
        action = "<cmd>Telescope buffers<CR>";
        key = "<Leader>fb";
        options = {
          silent = true;
          noremap = true;
          desc = "List buffers";
        };
      }
      {
        action = "<cmd>Telescope help_tags<CR>";
        key = "<Leader>fh";
        options = {
          silent = true;
          noremap = true;
          desc = "Help tags";
        };
      }
      {
        action = "<cmd>lua require'telescope.builtin'.lsp_definitions{}<CR>";
        key = "gd";
        options = {
          silent = true;
          noremap = true;
          desc = "Go to definition";
        };
      }
      {
        action = "<cmd>lua require'telescope.builtin'.git_files{}<CR>";
        key = "<Leader> ";
        options = {
          silent = true;
          noremap = true;
          desc = "List Git files";
        };
      }
      {
        action = "<cmd>lua require'telescope.builtin'.find_files{}<CR>";
        key = "<Leader>ff";
        options = {
          silent = true;
          noremap = true;
          desc = "List all files";
        };
      }
      {
        action = "<C-\\><C-n>";
        key = "<C-Esc>";
        options = {
          silent = true;
          noremap = true;
          desc = "Go to normal mode in built-in terminal.";
        };
        mode = "t";
      }
      {
        action = ":resize +4<CR>";
        key = "<Leader>w=";
        options = {
          silent = true;
          noremap = true;
          desc = "Increase window height.";
        };
      }
      {
        action = ":resize -4<CR>";
        key = "<Leader>w-";
        options = {
          silent = true;
          noremap = true;
          desc = "Decrease window height.";
        };
      }
      {
        action = ":vertical resize +4<CR>";
        key = "<Leader>w]";
        options = {
          silent = true;
          noremap = true;
          desc = "Increase window width.";
        };
      }
      {
        action = ":vertical resize -4<CR>";
        key = "<Leader>w[";
        options = {
          silent = true;
          noremap = true;
          desc = "Decrease window width.";
        };
      }
      {
        action = ":Bdelete!<CR>";
        key = "<Leader>bd";
        options = {
          silent = true;
          noremap = true;
          desc = "Close buffer";
        };
      }
      {
        action = ":bprev<CR>";
        key = "H";
        options = {
          silent = true;
          noremap = true;
          desc = "Move to the previous buffer.";
        };
      }
      {
        action = ":bnext<CR>";
        key = "L";
        options = {
          silent = true;
          noremap = true;
          desc = "Move to the next buffer.";
        };
      }
      {
        action = ":LazyGit<CR>";
        key = "<Leader>gg";
        options = {
          silent = true;
          noremap = true;
          desc = "Open LazyGit";
        };
      }
      {
        action = ":split | wincmd j | resize 15 | term<CR>";
        key = "<Leader>tt";
        options = {
          silent = true;
          noremap = true;
          desc = "Open a half-size horizontal terminal split";
        };
        mode = "n";
      }
      {
        action = ":split | wincmd j | term<CR>";
        key = "<Leader>te";
        options = {
          silent = true;
          noremap = true;
          desc = "Open a horizontal terminal split";
        };
        mode = "n";
      }
      {
        action = ":vsplit | wincmd l | term<CR>";
        key = "<Leader>tv";
        options = {
          silent = true;
          noremap = true;
          desc = "Open a vertical terminal split";
        };
        mode = "n";
      }
      {
        action = ":Trouble diagnostics<CR>";
        key = "<Leader>xx";
        options = {
          silent = true;
          noremap = true;
          desc = "View trouble diagnostics";
        };
        mode = "n";
      }
      {
        action = ":Trouble symbols<CR>";
        key = "<Leader>xs";
        options = {
          silent = true;
          noremap = true;
          desc = "View symbols";
        };
        mode = "n";
      }
      {
        action = "<Plug>(YankyPutAfter)";
        key = "p";
        mode = ["n" "x"];
      }
      {
        action = "<Plug>(YankyPutBefore)";
        key = "P";
        mode = ["n" "x"];
      }
      {
        action = "<Plug>(YankyGPutAfter)";
        key = "gp";
        mode = ["n" "x"];
      }
      {
        action = "<Plug>(YankyGPutBefore)";
        key = "gP";
        mode = ["n" "x"];
      }
      {
        action = ":Telescope yank_history<CR>";
        key = "<Leader>p";
        mode = "n";
      }
      {
        action = '':lua require("yazi").yazi()<CR>'';
        key = "<Leader>mm";
        options = {
          desc = "Open Yazi current nvim working directory";
          noremap = true;
          silent = true;
        };
      }
      {
        action = '':lua vim.lsp.buf.code_action()<CR>'';
        key = "<Leader>ca";
        options = {
          desc = "View available code actions";
          noremap = true;
          silent = true;
        };
      }
      {
        action = '':lua vim.lsp.buf.rename()<CR>'';
        key = "<Leader>cr";
        options = {
          desc = "Rename symbol";
          noremap = true;
          silent = true;
        };
      }
      # {
      #   action = ":Yazi<CR>";
      #   key = "<Leader>mf";
      #   options = {
      #     desc = "Open Yazi at current file";
      #     noremap = true;
      #     silent = true;
      #   };
      # }
      # {
      #   action = "<cmd>lua require'conform'.format({ bufnr = args.bf })<CR>";
      #   key = "<Leader>cf";
      #   options = {
      #     silent = true;
      #     noremap = true;
      #     desc = "Format buffer";
      #   };
      # }
    ];

    plugins = {
      # LSP and Treesitter related
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          bashls.enable = true;
          clangd.enable = true;
          pyright.enable = true;
          nixd.enable = true;
          nushell.enable = true;
          svelte.enable = true;
          tailwindcss.enable = true;
          typst-lsp.enable = true;
          marksman.enable = true;
        };
      };
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          folding.enable = true;
        };
      };
      lsp-lines.enable = true;
      crates-nvim.enable = true;
      treesitter-context.enable = true;

      # Language specific tools
      markdown-preview.enable = true;
      # rustaceanvim.enable = true;
      typescript-tools.enable = true;

      # git stuff
      lazygit.enable = true;
      gitsigns.enable = true;

      # QoL and utility
      intellitab.enable = true;
      guess-indent.enable = true;
      vim-bbye.enable = true;
      indent-blankline.enable = true;
      which-key.enable = true;
      zen-mode.enable = true;
      yanky = {
        enable = true;
        enableTelescope = true;
      };
      telescope = {
        enable = true;
        extensions = {
          ui-select = {
            enable = true;
            settings = {
              codeactions = true;
            };
          };
          media-files = {
            enable = true;
            settings = {
              filetypes = [
                "png"
                "webp"
                "jpg"
                "jpeg"
                "mp4"
                "svg"
                "pdf"
                "mov"
                "mkv"
                "avi"
              ];
              find_cmd = "rg";
            };
            dependencies = {
              imageMagick.enable = true;
              pdftoppm.enable = true;
              ffmpegthumbnailer.enable = true;
            };
          };
        };
      };
      trouble.enable = true;
      direnv.enable = true;
      yazi = {
        enable = true;
        settings = {
          open_for_directories = true;
        };
      };
      harpoon = {
        enable = true;
        keymaps = {
          addFile = "<Leader>hh";
          cmdToggleQuickMenu = "<Leader>hm";
          gotoTerminal = {
            "1" = "<Leader>ht";
            "2" = "<Leader>2";
            "3" = "<Leader>3";
            "4" = "<Leader>4";
          };
          navFile = {
            "1" = "<Leader>ha";
            "2" = "<Leader>hs";
            "3" = "<Leader>hd";
            "4" = "<Leader>hf";
          };
          navNext = "<Leader>h]";
          navPrev = "<Leader>h[";
          toggleQuickMenu = "<Leader>hk";
        };
      };

      # Code formatting
      conform-nvim = {
        enable = true;
        formatOnSave = {
          timeoutMs = 500;
          lspFallback = true;
        };
        formattersByFt = {
          lua = ["stylua"];
          python = ["black"];
          nix = ["alejandra"];
          svelte = ["prettier"];
          rust = ["rustfmt"];
          haskell = ["fourmolu"];
          "*" = ["codespell"];
          "_" = ["trim_whitespace"];
        };
      };

      # mini.nvim
      mini = {
        enable = true;
        modules = {
          surround = {};
          pairs = {};
          ai = {};
          hipatterns = {};
          notify = {};
          tabline = {};
          trailspace = {};
          comment = {};
          cursorword = {};
          bracketed = {};
        };
      };

      # Completion
      cmp-async-path.enable = true;
      cmp = {
        enable = true;
        settings = {
          autoEnableSources = true;
          experimental = {ghost_text = true;};
          performance = {
            debounce = 60;
            fetchingTimeout = 200;
            maxViewEntries = 30;
          };
          snippet = {expand = "luasnip";};
          formatting = {fields = ["kind" "abbr" "menu"];};
          sources = [
            {name = "nvim_lsp";}
            {name = "emoji";}
            {
              name = "buffer"; # text within current buffer
              option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
              keywordLength = 3;
            }
            # { name = "copilot"; } # enable/disable copilot
            {
              name = "path"; # file system paths
              keywordLength = 3;
            }
            {
              name = "luasnip"; # snippets
              keywordLength = 3;
            }
          ];

          window = {
            completion = {border = "solid";};
            documentation = {border = "solid";};
          };

          mapping = {
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<C-n>" = "cmp.mapping.select_next_item()";
            "<C-p>" = "cmp.mapping.select_prev_item()";
            "<C-e>" = "cmp.mapping.abort()";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          };
        };
      };
      cmp-nvim-lsp = {
        enable = true; # LSP
      };
      cmp-buffer = {
        enable = true;
      };
      cmp-path = {
        enable = true; # file system paths
      };
      cmp-cmdline = {
        enable = true; # autocomplete for cmdline
      };

      # Extra (stuff that doesn't affect editing)
      wakatime.enable = true;
      presence-nvim = {
        enable = true;
        editingText = "Hacking %s";
        workspaceText = "The One True Text Editor";
        buttons = [
          {
            label = "GitHub";
            url = "https://github.com/youwen5";
          }
          {
            label = "Code Forge";
            url = "https://code.youwen.dev/";
          }
        ];
      };
    };

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "satellite.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "lewis6991";
          repo = "satellite.nvim";
          rev = "777ed56e1ef45ec808df701730b6597fc4fb0fbc";
          hash = "sha256-04Js+9SB4VuCq/ACbNh5BZcolu8i8vlGU72qo5xxfpk=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "render-markdown.nvim";
        src = pkgs.fetchFromGitHub {
          owner = "MeanderingProgrammer";
          repo = "render-markdown.nvim";
          rev = "7986be47531d652e950776536987e01dd5b55b94";
          hash = "sha256-lc++IrXzEA3M2iUFZACAZOcH2EwVqX4p0fhET+en37o=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "haskell-tools-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "mrcjkb";
          repo = "haskell-tools.nvim";
          rev = "959eac0fadbdd27442904a8cb363f39afb528027";
          hash = "sha256-5CS5kvUSqQJe7iFFpicinBjCQXgFPL0ElGgnrZHTT+Y=";
        };
      })
      (pkgs.vimUtils.buildVimPlugin {
        name = "rustaceanvim";
        src = pkgs.fetchFromGitHub {
          owner = "mrcjkb";
          repo = "rustaceanvim";
          rev = "7cba8e599deca98d4b44cac1bcbd720c62937d90";
          hash = "sha256-OYfeJuo4FZUBdW9wGGCT0lZGYr/ur1uy8frcyUJMF3k=";
        };
      })
    ];
  };
}
