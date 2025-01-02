{
  lib,
  runCommand,
  nixosOptionsDoc,
  neovim,
  ...
}:
let
  # evaluate our options
  eval = lib.evalModules {
    modules = [ ../modules/default.nix ];
    check = false;
    specialArgs = {
      pkgs = {
        inherit neovim;
      };
    };
  };
  # generate our docs
  optionsDoc = nixosOptionsDoc {
    inherit (eval) options;
  };
in
# create a derivation for capturing the markdown output
runCommand "options-doc.md" { } ''
  tail -n +64 ${optionsDoc.optionsCommonMark} >> $out
''
