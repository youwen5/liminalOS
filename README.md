# liminalOS

This is a repository that implements liminalOS, my personal Linux distribution
based on [NixOS](https://nixos.org/).

Time wasted writing Nix code:
![](https://wakatime.com/badge/user/018dc5b8-ba5a-4572-a38a-b526d1b28240/project/c59b3d5e-0c9c-4bd5-a752-e75522ab0cdc.svg)

<!-- prettier-ignore -->
> **lim·i·nal**  
> 1. between or belonging to two different places, states, etc.

The goal of liminalOS is to allow my computing environment to exist in different
places (computers) at the same time, without the minor disparities, issues, and
inconsistencies that arise from traditional approaches such as scripting. This
works exceptionally well, demonstrated by the fact that I have the exact same
environment across three separate machines, spanning two completely different
CPU architectures.

Traditionally, we expect to configure each of our computers separately. We have
a general idea of the programs, settings, and minor tweaks that we like to make
on every computer, but we have to manually set all of these up. Many Unix
hackers have thus created sprawling installation scripts to manage their various
systems so they can be deployed in a predictable manner each time. Of course,
scripts are still heavily dependent on environment and prone to breakage. When
they inevitably break, the system is left in a malformed state, where some setup
actions have been taken and others have not, and it is up to the system
administrator to fix the failing script and ensure the system is set up
properly. Also, updating existing machines and rolling back to previous states
is a separate, even more difficult issue to solve with this approach.

In essence, the primary failure of setup scripts is that they are _imperative_ -
they must specify precisely _how_ to set up the system, down to minute details,
whereas in a _declarative_ approach, the user can simply specify what the system
_should look like_, and abstractions take care of the _how_. This is what NixOS
does, and it gives you remote syncing, versioning (via `git`), and rollbacks
_for free_.

NixOS provides the key tools for reliably deploying systems - namely, a _purely
functional_ package manager that's reproducible by default and the necessary
abstractions needed for a declarative system configuration. liminalOS is my set
of opinionated NixOS and `home-manager` modules that aim to set up a computing
environment _independent of the host_. This makes it possible for me to share
common configuration between a multitude of entirely distinct machines,
including an `x86_64` desktop, an `x86_64` laptop, an Apple Silicon Macbook
running NixOS `aarch64` using [Asahi Linux](https://asahilinux.org/), and the
same Macbook running macOS with `nix-darwin`, sharing `home-manager`
configuration with NixOS. Specific configuration necessary to adjust
hardware-specific details between each machines are isolated to the
[hosts](./hosts) directory.

## Installation guide

TBD. May use `deploy-rs` or the in-house
[dartgun](https://github.com/youwen5/dartgun) tool for easy deployment.

## FAQ

### This looks like a collection of NixOS configuration files and modules. What makes it a distinct distribution?

Most Linux[^1] users will agree that any self-respecting distribution must
include at least the following: installer, package manager, and some set of
default packages. Therefore, anything that implements the aforementioned items
must also be a Linux distribution.

liminalOS comes with the Nix package manager (nobody said you need a _unique_
package manager - Ubuntu and Debian are distinct distributions yet both use
`apt`), a custom desktop environment comprised of Waybar, Hyprland, rofi, as
well as various applications installed by default, and
[the means to generate an installer](https://nixos.wiki/wiki/Creating_a_NixOS_live_CD).
Therefore, liminalOS is a Linux distribution. QED.[^2]

### Should I actually install this?

No. You should instead use the modules as configuration examples if you need
them as they are heavily customized for my needs, which are not the same as
yours.

## Hosts

The modules in liminalOS are designed to be utilized by a wide variety of
machine configurations, including via nix-darwin on macOS. To that end, modules
are organized by operating system (darwin vs. linux), architecture (x86_64 vs.
aarch-64), and form factor (desktop vs laptop). Anything that is agnostic of
these distinctions is considered a "common module" and allows configuration to
be shared between the various host types. This generally includes core programs
like CLI tools, the window manager, etc.

The [flake.nix](/flake.nix) currently contains my configuration for four hosts:

| Hostname   | Description                                                                                                                                                         |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "callisto" | a Macbook Pro M1 (2021) running under Asahi Linux. Imports the laptop module sets as well as the core NixOS module sets.                                            |
| "demeter"  | a custom desktop with an i7-13700KF and RTX 4080. Imports the desktop module, the core NixOS modules, and additionally the gaming module.                           |
| "phobos"   | Macbook Pro M1 (2021) running macOS with nix-darwin. Imports the core home-manager module as well as some darwin-specific modules for window managers and the like. |
| "adrastea" | Razer Blade 14 (2021) with RTX 3070. Imports the laptop module, the core NixOS modules, and the gaming module.                                                      |

[^1]:
    also known as GNU/Linux, GNU+Linux, Freedesktop/systemd/musl/busybox Linux,
    Linux+friends, etc

[^2]:
    although this is not actually how the converse works, the rigor-hungry
    mathematicians reading can cry about it.

## Keybinds

| Shortcut                                                                                                 | Action                           |
| -------------------------------------------------------------------------------------------------------- | -------------------------------- |
| <kbd>Super</kbd> + <kbd>W</kbd>                                                                          | Toggle floating                  |
| <kbd>Super</kbd> + <kbd>J</kbd>                                                                          | Toggle layout                    |
| <kbd>Super</kbd> + <kbd>E</kbd>                                                                          | Open Dolphin                     |
| <kbd>Super</kbd> + <kbd>T</kbd>                                                                          | Open kitty                       |
| <kbd>Super</kbd> + <kbd>F</kbd>                                                                          | Open librewolf                   |
| <kbd>Super</kbd> + <kbd>R</kbd>                                                                          | Open pavucontrol                 |
| <kbd>Super</kbd> + <kbd>Space</kbd>                                                                      | Open rofi                        |
| <kbd>Super</kbd> + <kbd>Backspace</kbd>                                                                  | Open logout menu                 |
| <kbd>Super</kbd> + <kbd>P</kbd>                                                                          | Screenshot region                |
| <kbd>Super</kbd> + <kbd>Y</kbd><kbd>U</kbd><kbd>I</kbd><kbd>O</kbd>                                      | Move around                      |
| <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>Y</kbd><kbd>O</kbd>                                            | Move workspaces                  |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>Ctrl</kbd> + <kbd>Y</kbd><kbd>U</kbd><kbd>I</kbd><kbd>O</kbd>   | Move windows around workspaces   |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>Ctrl</kbd> + <kbd>Y</kbd><kbd>U</kbd><kbd>I</kbd><kbd>O</kbd> | Move windows around              |
| <kbd>Super</kbd> + <kbd>S</kbd>                                                                          | Open Special Workspace           |
| <kbd>Super</kbd> + <kbd>Enter</kbd>                                                                      | Fullscreen Window                |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>S</kbd>                                                         | Move Window to Special Workspace |
