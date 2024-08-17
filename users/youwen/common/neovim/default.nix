{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withRuby = true;

    extraPackages = with pkgs; [alejandra black stylua codespell];

    luaLoader.enable = true;

    colorschemes.gruvbox.enable = true;

    opts = {
      showmode = false;
    };

    globals = {
      mapleader = " ";
    };

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
        action = "<cmd>sp<CR>";
        key = "<Leader>-";
        options.silent = true;
        options.desc = "Split window horizontally";
      }
      {
        action = "<cmd>vsp<CR>";
        key = "<Leader>|";
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
      lualine = {
        enable = true;
        globalstatus = true;
      };
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          bashls.enable = true;
          clangd.enable = true;
          hls.enable = true;
          pyright.enable = true;
          nixd.enable = true;
          nushell.enable = true;
          svelte.enable = true;
          tailwindcss.enable = true;
          typst-lsp.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          marksman.enable = true;
        };
      };
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
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      wakatime.enable = true;
      lazygit.enable = true;
      intellitab.enable = true;
      guess-indent.enable = true;
      indent-blankline.enable = true;
      which-key.enable = true;
      zen-mode.enable = true;
      markdown-preview.enable = true;
      yanky = {
        enable = true;
        enableTelescope = true;
      };
      telescope = {
        enable = true;
      };
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
        };
      };
      trouble.enable = true;
      direnv.enable = true;
      cmp = {
        enable = true;
        settings = {
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-p>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping.confirm({ select = true })";
          };
          completion.autocomplete = [
            "require('cmp.types').cmp.TriggerEvent.TextChanged"
          ];
        };
      };
      cmp-async-path.enable = true;
      cmp-buffer.enable = true;
      cmp-conventionalcommits.enable = true;
      cmp-git.enable = true;
      cmp-nvim-lsp.enable = true;
      crates-nvim.enable = true;
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
          "*" = ["codespell"];
          "_" = ["trim_whitespace"];
        };
      };
    };
  };
}
