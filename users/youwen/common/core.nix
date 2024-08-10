{ pkgs, ... }: {
  home.file.".essentials" = {
    source = ./essentials;
    recursive = true;
  };

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

  programs.fzf = { enable = true; };

  programs.git = {
    enable = true;
    userName = "Youwen Wu";
    userEmail = "youwenw@gmail.com";
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
      commit.gpgsign = pkgs.lib.mkDefault "true";
      user.signingkey = "8F5E6C1AF90976CA7102917A865658ED1FE61EC3";
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

  programs.oh-my-posh = {
    enable = true;
    # enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    useTheme = "gruvbox";
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch";
      ls = "eza -l --icons=auto";
    };
    functions = {
      update-nixos = {
        description =
          "Update the system flake and attempt to build and switch to the new configuration.";
        body = ''
          cd /etc/nixos
          nix flake update
          sudo nixos-rebuild switch
        '';
      };
    };
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

  programs.fd.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "tokyo-night";
      vim_keys = true;
      theme_background = false;
    };
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
