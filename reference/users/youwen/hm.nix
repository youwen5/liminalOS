{ config, pkgs, ... }:
{

  imports = [
    ./secrets
    ./neomutt.nix
  ];

  home = {
    username = "youwen";
    homeDirectory = "/home/youwen";
  };

  liminalOS = {
    utils.easyeffects.enable = true;
    desktop.hyprland.screenlocker.useNvidiaCrashFix = true;
    desktop.hyprland.useAdvancedBindings = true;
  };

  programs.git = {
    userName = "Youwen Wu";
    userEmail = "youwenw@gmail.com";
    signing = {
      signByDefault = true;
      key = "8F5E6C1AF90976CA7102917A865658ED1FE61EC3";
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

    alexa = ''
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
