{
  config,
  pkgs,
  inputs,
  osConfig,
  ...
}:
{

  imports = [
    ./secrets
    ./neomutt.nix
    inputs.zenTyp.homeManagerModules.default
  ];

  zenTyp.enable = true;
  zenTyp.compat = true;

  home = {
    username = "youwen";
    homeDirectory = "/home/youwen";
  };

  liminalOS = {
    utils.easyeffects.enable = true;
  };

  programs.git = {
    userName = "Youwen Wu";
    userEmail = "youwenw@gmail.com";
    signing = {
      signByDefault = true;
      key = "8F5E6C1AF90976CA7102917A865658ED1FE61EC3";
    };
  };

  programs.iamb = {
    enable = true;
    package = inputs.iamb.packages.${pkgs.stdenv.targetPlatform.system}.default;
    settings = {
      default_profile = "functor.systems";
      profiles = {
        "functor.systems" = {
          user_id = "@youwen:functor.systems";
          url = "https://matrix.functor.systems";
        };
        "matrix.org".user_id = "@youwen:matrix.org";
        "nixos.dev".user_id = "@youwen5:nixos.dev";
      };
      settings = {
        image_preview = { };
        notifications.enabled = true;
        users = {
          "@ananthv:matrix.mit.edu".color = "magenta";
        };
        username_display = "regex";
        username_display_regex = "discord_";
      };
      layout.style = "restore";
      dirs.downloads = "/tmp";
      macros.normal = {
        "gc" = ":chats<Enter>";
        "gr" = ":rooms<Enter>";
        "gs" = ":spaces<Enter>";
        "gd" = ":dms<Enter>";
        "gu" = ":unreads<Enter>";
        "ZZ" = ":qa<Enter>";
      };
    };
  };

  # must set identitiesOnly since we are adding a ton of SSH keys to ssh-agent and it tries all of them
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "code.youwen.dev" = {
        host = "code.youwen.dev";
        # port = 222;
        identityFile = config.age.secrets.youwen_dev_ssh_priv_key.path;
        identitiesOnly = true;
      };
      "provenance.kaitotlex.systems" = {
        host = "code.functor.systems";
        port = 26;
        # identityFile = config.age.secrets.youwen_dev_ssh_priv_key.path;
        # identitiesOnly = true;
      };
      "github" = {
        host = "github.com";
        identityFile = config.age.secrets.github_ssh_priv_key.path;
        identitiesOnly = true;
      };
      "gallium" = {
        host = "gallium";
        port = 222;
        identityFile = config.age.secrets.gallium_server_ssh.path;
        identitiesOnly = true;
      };
      "truth.youwen.dev" = {
        host = "truth.youwen.dev";
        port = 222;
        identitiesOnly = true;
        identityFile = config.age.secrets.gallium_server_ssh.path;
      };
    };
    addKeysToAgent = "yes";
  };

  xdg.configFile."harper-ls" = {
    source = config.lib.file.mkOutOfStoreSymlink "${osConfig.liminalOS.flakeLocation}/reference/users/youwen/config/harper-ls";
    recursive = true;
  };

  # text/html;      ~/.mutt/view_attachment.sh %s html;     test=test -n "$DISPLAY"
  home.file.".mailcap".text = ''
    text/html;      ${pkgs.w3m}/bin/w3m %s;     nametemplate=%s.html;       needsterminal
    text/html;      ${pkgs.w3m}/bin/w3m -v -F -T text/html -dump %s;        copiousoutput
  '';

  programs.fish.functions = {
    vault = ''
      set vault_dir $HOME/Documents/vaults/vault

      if test -d $vault_dir
          cd $vault_dir
          git pull
          vim
      else
          echo "Vault is not yet cloned. Cloning repository now."
          mkdir -p $HOME/Documents/vaults
          cd $HOME/Documents/vaults
          git clone git@code.youwen.dev:youwen5/vault.git
          cd $vault_dir
          nvim -c "Telescope find_files"
      end
    '';

    ale = ''
      set vault_dir $HOME/Documents/alexandria/content

      if test -d $vault_dir
          cd $vault_dir
          git pull
          vim
      else
          echo "Vault is not yet cloned. Cloning repository now."
          mkdir -p $HOME/Documents
          cd $HOME/Documents
          git clone git@code.youwen.dev:youwen5/alexandria.git
          cd $vault_dir
          nvim -c "Telescope find_files"
      end
    '';
  };
}
