{
  description = "Minimal standalone functorOS system";

  inputs = {
    # Follow the nixpkgs in functorOS, which is verified to build properly before release.
    functorOS.url = "git+https://code.functor.systems/functor.systems/functorOS.git";
    nixpkgs.follows = "functorOS/nixpkgs";

    # Alternatively, pin your own nixpkgs and set functorOS to follow it, as shown below.

    # nixpkgs.follows = "github:nixos/nixpkgs?ref=nixos-unstable";
    # functorOS.url = "github:youwen5/functorOS";
    # functorOS.inputs.nixpkgs.follows = "nixpkgs";

    # Either way, you should ensure that functorOS shares nixpkgs with your
    # system to avoid any weird conflicts.
  };

  outputs =
    inputs@{
      nixpkgs,
      self,
      functorOS,
      ...
    }:
    let
      functorOSLib = import functorOS {
        inherit
          inputs
          self
          nixpkgs
          functorOS
          ;
      };
      exampleUser = functorOSLib.user.instantiate {
        # Linux username for your user
        username = "example-user";

        # Absolute path to the home directory
        homeDirectory = "/home/example-user";

        # Full name. This is really just the string provided in the
        # `description` field of your Linux user, which is generally the user's
        # full name.
        fullName = "Example User";

        # Email address of user
        email = "exampleuser@functor.systems";

        # If you set this to true, Git will automatically be configured with the fullName and email set above.
        configureGitUser = true;

        # This is treated just like a standard `home.nix` home-manager
        # configuration file.
        configuration = {
          # You can set arbitrary options here. For example, if your
          # home-manager configuration is in another file, then import it like
          # so:
          # imports = [
          # ./home.nix
          # ];
          # Or any other option, like
          # programs.neovim.enable = true;
          # programs.neovim.settings = { # --snip-- };

          # Let's set the home-manager state version.

          # This value determines the NixOS release from which the default
          # settings for stateful data, like file locations and database versions
          # on your system were taken. It‘s perfectly fine and recommended to leave
          # this value at the release version of the first install of home-manager.
          home.stateVersion = "25.05";
        };
      };
    in
    {
      # Execute sudo nixos-rebuild switch --flake .#functorOS
      nixosConfigurations = {
        functorOS = functorOSLib.system.instantiate {
          hostname = "functorOS";

          # List of users generated with functorOSLib.user.instantiate.
          users = [ exampleUser ];

          # Additional system configuration.
          configuration =
            { pkgs, ... }:
            {
              # This is treated just like a standard configuration.nix file.

              # You can set any arbitrary NixOS options here. For example, don't
              # forget to import hardware-configuration.nix:

              # The included hardware-configuration.nix in this template is a placeholder.
              # The system WILL NOT build until you import your own!

              # You need to import your `hardware-configuration.nix`. If you don't have it,
              # run `nixos-generate-config` and it will be automatically populated at
              # /etc/nixos/hardware-configuration.nix.

              # Simply copy that file over into the same directory as your
              # `flake.nix`, replacing the existing placeholder file.
              imports = [ ./hardware-configuration.nix ];

              # Set up a bootloader:
              boot = {
                loader = {
                  efi.canTouchEfiVariables = true;
                  timeout = 15;
                  systemd-boot.enable = true;
                };

                # (optionally) Select a kernel.
                # kernelPackages = pkgs.linuxPackages_zen;
              };

              # Make sure to set the state version of your NixOS install! Find
              # it in your existing /etc/nixos/configuration.nix.

              # This value determines the NixOS release from which the default
              # settings for stateful data, like file locations and database versions
              # on your system were taken. It‘s perfectly fine and recommended to leave
              # this value at the release version of the first install of this system.
              # Before changing this value read the documentation for this option
              # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
              system.stateVersion = "24.05"; # Did you read the comment?

              # Other options such as
              # hardware.graphics.enable = true
              # work fine here too.

              # -----------------------------------------------------------------------

              # The functorOS option below is a special option generated by
              # functorOS, and used to configure it.

              # Don't panic! Documentation for functorOS.* system options is
              # available at <https://os.functor.systems>
              functorOS = {
                # Set this to the absolute path of the location of this configuration flake
                # to enable some UX enhanacements
                flakeLocation = null;

                # Allow functorOS's unfree packages
                # This option doesn't set allowUnfree for the whole system,
                # rather, it simply allows a specifically curated list of
                # unfree packages in functorOS
                config.allowUnfree = false;

                # Set your default editor to any program.
                defaultEditor = pkgs.neovim;

                # Set to either "laptop" or "desktop" for some adjustments
                formFactor = "desktop";

                # Set a wallpaper to whatever you want! You can use a local path as well.
                # The colorscheme for the system is automatically generated from this
                # wallpaper!
                theming = {
                  wallpaper = pkgs.fetchurl {
                    url = "https://w.wallhaven.cc/full/l8/wallhaven-l8x1pr.jpg";
                    hash = "sha256-Ts8igtDxLsnAnpy+tiGAXVhJWYLMHGOb2fd8lpV+UnM=";
                  };
                };
                system = {
                  # Toggle true to enable audio production software, like
                  # reaper, and yabridge + 64 bit wine for installing
                  # Windows-exclusive VSTs! Also sets realtime kernel
                  # configuration and other optimizations.
                  audio.prod.enable = false;

                  networking = {
                    # Toggle on to allow default vite ports of 5173 and 4173 through the firewall for local testing.
                    firewallPresets.vite = false;
                    # Use cloudflare's 1.1.1.1 DNS servers.
                    cloudflareNameservers.enable = true;
                  };
                  # Set some sane defaults for nvidia graphics, like proprietary drivers.
                  # WARNING: requires functorOS.config.allowUnfree to be set to true.
                  graphics.nvidia.enable = false;
                };
                extras.gaming = {
                  # Enable gaming utilities, like Lutris, Steam, Prism Launcher, etc.
                  enable = false;
                  # Installs Roblox using Sober, as a flatpak. Note that this will enable
                  # the impure flatpak service that automatically updates flatpaks every
                  # week upon nixos-rebuild switch
                  roblox.enable = false;

                  utilities.gamemode = {
                    # Enable the gamemoderun binary to maximize gaming performance
                    enable = false;
                    # Don't forget to update this if you change your username!
                    gamemodeUsers = [ "example-user" ];
                  };
                };
              };
            };
        };
      };
    };
}
