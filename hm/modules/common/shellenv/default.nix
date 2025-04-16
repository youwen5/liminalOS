{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  cfg = config.liminalOS;
in
{
  imports = [
    ./fastfetch
  ];

  options.liminalOS.shellEnv = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to set up a CLI development environment.
      '';
    };
  };

  config = lib.mkIf cfg.shellEnv.enable {

    programs.bash.enable = true;

    programs.nushell =
      let
        zoxideInit = pkgs.stdenvNoCC.mkDerivation {
          inherit (pkgs.zoxide) version;
          pname = "zoxide-init";
          nativeBuildInputs = [ pkgs.zoxide ];
          phases = [ "installPhase" ];
          installPhase = ''
            zoxide init nushell >> $out
          '';
        };
      in
      {
        enable = true;
        configFile.source = ./config.nu;
        settings = {
          show_banner = false;
          completions.external = {
            enable = true;
            max_results = 200;
          };
          edit_mode = "vi";
          cursor_shape = {
            emacs = "line";
            vi_insert = "line";
            vi_normal = "block";
          };
        };
        extraConfig = lib.mkIf config.programs.zoxide.enable ''
          source "${zoxideInit}"
          def "nu-complete zoxide path" [context: string] {
            let parts = $context | split row " " | skip 1
            {
              options: {
                sort: false
                completion_algorithm: prefix
                positional: false
                case_sensitive: false
              }
              completions: (zoxide query --list --exclude $env.PWD -- ...$parts | lines)
            }
          }

          def --env --wrapped z [...rest: string@"nu-complete zoxide path"] {
            __zoxide_z ...$rest
          }
        '';
        plugins = with pkgs.nushellPlugins; [ polars ];
      };

    programs.fzf = {
      enable = true;
    };

    programs.git = {
      enable = true;
      userName = lib.mkDefault "liminalOS user";
      userEmail = lib.mkDefault "liminalOS@localhost";
      delta.enable = true;
      maintenance.enable = true;
      extraConfig = {
        init.defaultBranch = "main";
        safe.directory = lib.mkIf (
          osConfig.liminalOS.flakeLocation != null
        ) osConfig.liminalOS.flakeLocation;
      };
    };

    home.packages = [ pkgs.git-absorb ];

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
      # we have our own fish completion plugin for zoxide
      enableFishIntegration = false;
      # we have our own nushell completion plugin for zoxide
      enableNushellIntegration = false;
      enableBashIntegration = true;
      package =
        if
          (lib.versionAtLeast pkgs.zoxide.version "0.9.7" || lib.versionOlder pkgs.nushell.version "0.102.0")
        then
          pkgs.zoxide
        else
          pkgs.zoxide.overrideAttrs (
            finalAttrs: prevAttrs: {
              version = "0.9.7";
              src = pkgs.fetchFromGitHub {
                owner = "ajeetdsouza";
                repo = "zoxide";
                rev = "v${finalAttrs.version}";
                hash = "sha256-+QZpLMlHOZdbKLFYOUOIRZHvIsbMDdstj9oGzyEGVxk=";
              };

              cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
                inherit (finalAttrs) src;
                hash = "sha256-uqIL8KTrgWzzzyoPR9gctyh0Rf7WQpTGqXow2/xFvCU=";
              };
            }
          );
    };

    programs.gh = {
      enable = true;
    };

    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
    };

    home.file.".config/starship.toml".text = builtins.readFile ./jetpack.toml;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      config.global.hide_env_diff = true;
    };

    programs.fish = {
      enable = true;
      shellAliases = {
        ls = "eza -l --icons=auto";
        neofetch = "${pkgs.fastfetch}/bin/fastfetch";
      };
      interactiveShellInit = ''
        fish_vi_key_bindings
        set -g fish_greeting
      '';
      plugins =
        [
          {
            name = "autopair";
            src = pkgs.fishPlugins.autopair.src;
          }
          {
            name = "fzf";
            src = pkgs.fishPlugins.fzf.src;
          }
          {
            name = "done";
            src = pkgs.fishPlugins.done.src;
          }
          {
            name = "sponge";
            src = pkgs.fishPlugins.sponge.src;
          }
        ]
        ++ lib.optionals config.programs.zoxide.enable [
          {
            name = "zoxide.fish";
            src = pkgs.fetchFromGitHub {
              owner = "icezyclon";
              repo = "zoxide.fish";
              rev = "a6dabb16dd2de570a2005617ea4510f0beb6dc53";
              hash = "sha256-aGajwgFdB+wtjyryD/EQXSQ3SCFKwDJFjaZjLiJHt3E=";
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
        vim_keys = true;
        theme_background = false;
      };
    };

    programs.eza = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      enableNushellIntegration = false;
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
  };
}
