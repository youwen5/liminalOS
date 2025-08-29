# functorOS

A highly experimental NixOS-based Linux distribution, descended from liminalOS.

Currently under heavy development and not suitable for daily use. Please see
[the project wiki](https://code.functor.systems/functor.systems/functorOS/wiki) for more details.

See [os.functor.systems](https://os.functor.systems/) for module options.

## Try it

functorOS is ready for power users to test drive. You first need to install
NixOS on your desired machine. To install functorOS, run the following command
and look inside `flake.nix`, containing a minimal self-documenting
configuration for functorOS.

```sh
nix flake init -t "git+https://code.functor.systems/functor.systems/functorOS"
```
