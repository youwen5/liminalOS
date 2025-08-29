# IMPORTANT: you need to replace this file!
# ----------------------------------------------------------------
# You need to import your `hardware-configuration.nix`. If you don't have it,
# run `nixos-generate-config` and it will be automatically populated at
# /etc/nixos/hardware-configuration.nix.

# Simply copy that file over into the same directory as your `flake.nix`,
# replacing this file, which is a `hardware-configuration.nix`
# placeholder that prints this message.

{
  # Only being set so that the assertion below triggers instead.
  nixpkgs.hostPlatform = {
    system = "x86_64-linux";
  };

  assertions = [
    {
      assertion = false;
      message = ''
        HEY THERE! READ THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

        If you're seeing this message, you forgot to import your
        `hardware-configuration.nix`. If you don't have it, run
        `nixos-generate-config` and it will be automatically populated at
        /etc/nixos/hardware-configuration.nix. 

        Simply copy that file over into the same directory as your `flake.nix`,
        replacing this file, which is a `hardware-configuration.nix`
        placeholder that prints this message.

        IMPORTANT: You can ignore all other errors that may appear above or
        below this message until you import your hardware-configuration.nix as
        described above.
      '';
    }
  ];
}
