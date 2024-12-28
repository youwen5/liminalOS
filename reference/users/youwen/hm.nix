{ osConfig, pkgs, ... }:
let
  inherit (osConfig.age) secrets;
  gpgSig = "8F5E6C1AF90976CA7102917A865658ED1FE61EC3";
  oauth = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/neomutt/neomutt/a3b70e7edf84048e47e002e34388a4bc896e44ac/contrib/oauth2/mutt_oauth2.py";
    hash = "sha256-5mN+W1q9i9XiEtRTYIH0/qXpvfmkxOs71g9wM5vtfbU=";
  };
in
{
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
      key = gpgSig;
    };
  };

  home.packages = [
    # a script to automatically refresh oauth token for gsuite
    (pkgs.writeShellScriptBin "activate-neomutt-oauth" ''
      ${pkgs.python39}/bin/python ${oauth} youwen@ucsb.edu.tokens \
        --provider google \
        --verbose \
        --test \
        --authorize \
        --authflow localhostauthcode \
        --client-id "''$(cat ${secrets.youwen_ucsb_client_id.path})" \
        --client-secret "''$(cat ${secrets.youwen_ucsb_client_secret.path})"
    '')
  ];

  programs.neomutt = {
    enable = true;
    editor = "nvim";
    sidebar.enable = true;
    sort = "reverse-date-received";
    vimKeys = true;
    checkStatsInterval = 60;

    # without this, neomutt won't use the cache because the messages directory
    # doesn't exist
    extraConfig = ''
      set my_create_cache_folders = `mkdir -p ~/.cache/neomutt/messages`

      macro index,pager \cs "<pipe-message> ${pkgs.urlscan}/bin/urlscan<Enter>" "call urlscan to extract URLs out of a message"
      macro attach,compose \cs "<pipe-entry> ${pkgs.urlscan}/bin/urlscan<Enter>" "call urlscan to extract URLs out of a message"
    '';
  };

  accounts.email.accounts = {
    "youwenw" = {
      address = "youwenw@gmail.com";
      flavor = "gmail.com";
      userName = "youwenw";
      primary = true;
      realName = "Youwen Wu";
      gpg.encryptByDefault = true;
      gpg.signByDefault = true;
      gpg.key = gpgSig;
      folders.drafts = "[Gmail]/Drafts";
      neomutt = {
        enable = true;
        mailboxType = "imap";
      };
      passwordCommand = "cat ${secrets.youwen_app_password.path}";
    };

    "tincan" = {
      address = "tincangto@gmail.com";
      flavor = "gmail.com";
      userName = "tincangto";
      realName = "Youwen Wu";
      folders = {
        drafts = "[Gmail]/Drafts";
        trash = "[Gmail]/Trash";
      };
      neomutt = {
        enable = true;
        mailboxType = "imap";
      };
      passwordCommand = "cat ${secrets.tincan_app_password.path}";
    };

    "youwen_ucsb" = {
      address = "youwen@ucsb.edu";
      flavor = "gmail.com";
      userName = "youwen_ucsb";
      realName = "Youwen Wu";
      gpg.encryptByDefault = true;
      gpg.signByDefault = true;
      gpg.key = "D26A00824013D524BDF11126093F1185C55B84A2";
      folders.drafts = "[Gmail]/Drafts";
      neomutt = {
        enable = true;
        mailboxType = "imap";

        extraConfig = ''
          unset passwordCommand
          set imap_user = "youwen@ucsb.edu"
          set imap_authenticators="oauthbearer:xoauth2"
          set imap_oauth_refresh_command = "${pkgs.python39}/bin/python ${oauth} youwen@ucsb.edu.tokens"

          set smtp_authenticators = ''${imap_authenticators}
          set smtp_oauth_refresh_command = ''${imap_oauth_refresh_command}
        '';
      };
      passwordCommand = "";
    };
  };
}
