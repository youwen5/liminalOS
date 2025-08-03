{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.liminalOS.desktop.localization;
in
{
  options.liminalOS.desktop.localization = {
    chinese.input.enable = lib.mkEnableOption "Chinese input method using fcitx5.";
    chinese.script = lib.mkOption {
      type = lib.types.enum [
        "simplified"
        "traditional"
      ];
      default = "simplified";
      description = ''
        Whether to use simplified or traditional characters.
      '';
    };
  };

  config = lib.mkIf cfg.chinese.input.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        fcitx5-chinese-addons
        fcitx5-tokyonight
      ];
      fcitx5.settings.globalOptions = {
        Hotkey = {
          # Enumerate when press trigger key repeatedly
          EnumerateWithTriggerKeys = true;
          # Temporally switch between first and current Input Method
          AltTriggerKeys = null;
          # Enumerate Input Method Forward
          EnumerateForwardKeys = null;
          # Enumerate Input Method Backward
          EnumerateBackwardKeys = null;
          # Skip first input method while enumerating
          EnumerateSkipFirst = false;
          # Enumerate Input Method Group Forward
          EnumerateGroupForwardKeys = null;
          # Enumerate Input Method Group Backward
          EnumerateGroupBackwardKeys = null;
          # Activate Input Method
          ActivateKeys = null;
          # Deactivate Input Method
          DeactivateKeys = null;
          # Default Previous page
          PrevPage = null;
          # Default Next page
          NextPage = null;
          # Default Previous Candidate
          PrevCandidate = null;
          # Default Next Candidate
          NextCandidate = null;
          # Toggle embedded preedit
          TogglePreedit = null;
          # Time limit in milliseconds for triggering modifier key shortcuts
          ModifierOnlyKeyTimeout = 250;
        };

        "Hotkey/TriggerKeys" = {
          "0" = "Control+Super+space";
          "1" = "Zenkaku_Hankaku";
          "2" = "Hangul";
        };

        Behavior = {
          # Active By Default;
          ActiveByDefault = false;
          # Reset state on Focus In;
          resetStateWhenFocusIn = "No";
          # Share Input State;
          ShareInputState = "No";
          # Show preedit in application;
          PreeditEnabledByDefault = true;
          # Show Input Method Information when switch input method;
          ShowInputMethodInformation = true;
          # Show Input Method Information when changing focus;
          showInputMethodInformationWhenFocusIn = false;
          # Show compact input method information;
          CompactInputMethodInformation = true;
          # Show first input method information;
          ShowFirstInputMethodInformation = true;
          # Default page size;
          DefaultPageSize = 10;
          # Override Xkb Option;
          OverrideXkbOption = false;
          # Custom Xkb Option;
          CustomXkbOption = "";
          # Force Enabled Addons;
          EnabledAddons = "";
          # Force Disabled Addons;
          DisabledAddons = "";
          # Preload input method to be used by default;
          PreloadInputMethod = true;
          # Allow input method in the password field;
          AllowInputMethodForPassword = false;
          # Show preedit text when typing password;
          ShowPreeditForPassword = false;
          # Interval of saving user data in minutes;
          AutoSavePeriod = 30;

        };
      };
      fcitx5.settings.inputMethod = {
        "Groups/0" = {
          # Group Name
          Name = "Default";
          # Layout
          "Default Layout" = "us";
          # Default Input Method
          DefaultIM = "pinyin";
        };
        "Groups/0/Items/0" = {
          # Name
          Name = "keyboard-us";
          # Layout
          Layout = "";
        };

        "Groups/0/Items/1" = {
          # Name
          Name = "pinyin";
          # Layout
          Layout = "";
        };

        "GroupOrder" = {
          "0" = "Default";
        };

      };
    };
  };
}
