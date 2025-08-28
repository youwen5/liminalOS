{
  lib,
  runCommand,
  nixosOptionsDoc,
  neovim,
  hash,
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
  tail -n +64 ${optionsDoc.optionsCommonMark} \
    | sed -E 's#\[/nix/store/[a-z0-9]+-source(/[^]]*)\]\(file:///nix/store/[a-z0-9]+-source([^)]*)\)#[\1](https://code.functor.systems/functor.systems/functorOS/src/commit/${hash}\2)#g' \
    >> $out
''
