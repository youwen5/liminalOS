{ pkgs, ... }:
let
  inherit (builtins) readFile;
in
{
  home.file.".essentials" = {
    source = ./essentials;
    recursive = true;
  };

  home.file.".gitignore".text = ''
    result
    .direnv/
  '';

  programs.bash.enable = true;
  programs.nushell = {
    enable = true;
    configFile.text = ''
      $env.config = {
        edit_mode: vi,
        show_banner: false
      }
    '';
  };

  programs.fzf = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Youwen Wu";
    userEmail = "youwenw@gmail.com";
    delta.enable = true;
    maintenance.enable = true;
    signing = {
      signByDefault = true;
      key = "8F5E6C1AF90976CA7102917A865658ED1FE61EC3";
    };
    extraConfig = {
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos/.git";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      git.paging = {
        colorArg = "always";
        pager = "delta --dark --paging=never";
      };
    };
  };

  programs.bat.enable = true;

  programs.ripgrep.enable = true;

  programs.readline = {
    enable = true;
    extraConfig = "set editing-mode vi";
  };

  programs.zoxide = {
    enable = true;
    # enableZshIntegration = true;
    enableFishIntegration = true;
    enableNushellIntegration = true;
  };

  programs.gh = {
    enable = true;
    extensions = [ pkgs.github-copilot-cli ];
  };

  # programs.oh-my-posh = {
  #   enable = true;
  #   # enableZshIntegration = true;
  #   enableFishIntegration = true;
  #   enableBashIntegration = true;
  #   useTheme = "gruvbox";
  # };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };

  home.file.".config/starship.toml".text = readFile ./jetpack.toml;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config = {
      global.hide_env_diff = true;
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza -l --icons=auto";
      neofetch = "${pkgs.fastfetch}/bin/fastfetch";
    };
    # shellInit = ''
    #   oh-my-posh disable notice
    # '';
    interactiveShellInit = ''
      fish_vi_key_bindings
      set -g fish_greeting
    '';
    plugins = [
      {
        name = "autopair";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
          hash = "sha256-qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
        };
      }
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "8920367cf85eee5218cc25a11e209d46e2591e7a";
          hash = "sha256-T8KYLA/r/gOKvAivKRoeqIwE2pINlxFQtZJHpOy9GMM=";
        };
      }
      {
        name = "sponge";
        src = pkgs.fetchFromGitHub {
          owner = "meaningful-ooo";
          repo = "sponge";
          rev = "384299545104d5256648cee9d8b117aaa9a6d7be";
          hash = "sha256-MdcZUDRtNJdiyo2l9o5ma7nAX84xEJbGFhAVhK+Zm1w=";
        };
      }
      {
        name = "done";
        src = pkgs.fetchFromGitHub {
          owner = "franciscolourenco";
          repo = "done";
          rev = "eb32ade85c0f2c68cbfcff3036756bbf27a4f366";
          hash = "sha256-DMIRKRAVOn7YEnuAtz4hIxrU93ULxNoQhW6juxCoh4o=";
        };
      }
    ];
  };

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.nix-index-database.comma.enable = true;

  programs.fd.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      # color_theme = "tokyo-night";
      vim_keys = true;
      theme_background = false;
    };
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    git = true;
  };

  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    plugins = {
      mediainfo = pkgs.fetchFromGitHub {
        owner = "Ape";
        repo = "mediainfo.yazi";
        rev = "c69314e80f5b45fe87a0e06a10d064ed54110439";
        hash = "sha256-8xdBPdKSiwB7iRU8DJdTHY+BjfR9D3FtyVtDL9tNiy4=";
      };
    };
    settings = {
      plugin = {
        prepend_previewers = [
          {
            mime = "{image,audio,video}/*";
            run = "mediainfo";
          }
          {
            mime = "application/x-subrip";
            run = "mediainfo";
          }
        ];
      };
    };
  };

  programs.zathura.enable = true;
}
