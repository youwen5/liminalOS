# liminalOS

This is a repository that implements liminalOS, my personal Linux distribution
based on [NixOS](https://nixos.org/).

Time wasted writing Nix code:
![](https://wakatime.com/badge/user/018dc5b8-ba5a-4572-a38a-b526d1b28240/project/c59b3d5e-0c9c-4bd5-a752-e75522ab0cdc.svg) + [![wakatime](https://wakatime.com/badge/user/018dc5b8-ba5a-4572-a38a-b526d1b28240/project/de5e82f8-8a09-42cb-ae45-9c80f2ab5a41.svg)](https://wakatime.com/badge/user/018dc5b8-ba5a-4572-a38a-b526d1b28240/project/de5e82f8-8a09-42cb-ae45-9c80f2ab5a41)

These are essentially just my NixOS configuration files. I use flakes,
home-manager, `agenix`, all the buzzwords. But it sounds cool to have your own
OS! (and NixOS is essentially a purpose-built language and ecosystem to allow
you to build your own immutable operating system anyways.)

Many have written at length about the virtues of NixOS and _declarative
configuration_ and _immutability_ and such. I doubt what I have to say is
particularly novel, but I'll leave a few thoughts about Nix and NixOS and why
they do things better anyways. Essentially: allow me to introduce you to the
origins of [NixOS God
Complex](https://www.reddit.com/r/NixOS/comments/kauf1m/dealing_with_post_nixflake_god_complex/).

If you would like advice on whether or not to use NixOS:

<details> <summary>see <a
href="https://github.com/hlissner/dotfiles">hlissner's</a> breakdown,
reproduced below:</summary> Should I use NixOS?

Short answer: no.

Long answer: no really. Don't.

Long long answer: I'm not kidding. Don't.

Unsigned long long answer: Alright alright. Here's why not:

Its learning curve is steep. You will trial and error your way to
enlightenment, if you survive the frustration long enough. NixOS is unlike
other Linux distros. Your issues will be unique and difficult to google. A
decent grasp of Linux and your chosen services is a must, if only to
distinguish Nix(OS) issues from Linux (or upstream) issues -- as well as to
debug them or report them to the correct authority (and coherently). If words
like "declarative", "generational", and "immutable" don't put your sexuality in
jeopardy, you're considering NixOS for the wrong reasons. The overhead of
managing a NixOS config will rarely pay for itself with 3 systems or fewer
(perhaps another distro with nix on top would suit you better?). Official
documentation for Nix(OS) is vast, but shallow. Unofficial resources and
example configs are sparse and tend toward too simple or too complex (and most
are outdated). Case in point: this repo. The Nix language is obtuse and its
toolchain is not intuitive. Your experience will be infinitely worse if
functional languages are alien to you, however, learning Nix is a must to do
even a fraction of what makes NixOS worth the trouble. If you need somebody
else to tell you whether or not you need NixOS, you don't need NixOS.
</details>

<hr />

<!-- prettier-ignore -->
> **lim·i·nal**
> 1. between or belonging to two different places, states, etc.

The goal of liminalOS is to allow my computing environment to exist in
different computers at the same time, and to be absolutely unbreakable while
doing so. Let's talk about existing in multiple computers first, or otherwise
known as some form of "settings sync". To the typical user, stuck in the
_imperative world_, this sounds unrealistic at worst, and janky at best.
Generally, people encounter environment or settings syncing in two ways: either
the entire service is ran in the cloud, so it's really the _same_ environment
accessed from multiple places, or it's some often half baked opaque solution
involving you making an account and sending all your settings to a sync server
(see: Mozilla Firefox).

The more technically minded may instead opt to create a "dotfiles" repository,
holding their vast corpus of meticulously crafted configuration files. These
repos often come with a janky `install.sh` that does its best to throw all the
files into the correct place. This usually works the first time, but trying to
keep the installed dotfiles in sync with a central repository is a whole other
problem.

But these solutions are generally used for singular services or applications.
Keeping an entire _system_ synced up across computers down to the minute
configurations and applications seems incredibly unwieldy, through our usual
conception of how we interact with our operating systems.

The more obsessive system tweakers might try a dotfile manager like `chezmoi`
or GNU Stow. I have not tried these so I make no judgements on their utility,
but generally these solutions miss a key feature: they provide the
configuration, but don't install the software. But the software and the
configuration are fundamentally tied together; these are not concerns to be
separated. If the software is installed, it almost always needs to be
configured anyways. If the configuration exists, the software should be
installed.

So, *nix hackers reach for things like [Ansible](https://www.ansible.com/), that
promise automatic configuration of entire systems. Though Ansible was designed
to deploy cloud servers quickly through the Infrastructure-as-Code approach,
some people opt to use it for deploying their systems quickly as well. I have
not tried it, but from what I've heard, it works fine for simple deployment but
gets quite unwieldy for more complex purposes (especially for personal systems,
which aren't expected to be as ephemeral as servers).

If you agree with the premises I've laid out up to this point,  you might come
to the conclusion that I've made: to solve this issue, we need a solution that
does _all of it_. A unified tool for deploying software and managing systems.
And it must necessarily be declarative and reproducible.

Well, [Nix](https://nixos.org/) is the _purely functional_ package manager
(i.e. declarative, reproducible), and NixOS is a Linux distribution that is
managed entirely by Nix. Essentially, Nix provides a solution to the problem of
_software deployment_, and in fact was purpose built to do so in Eelco
Dolstra's seminal [PhD
thesis](https://edolstra.github.io/pubs/phd-thesis.pdf). NixOS is a system that
takes the power of Nix and applies it to declaratively configure an _entire
Linux system_. All of the software can be specified precisely using the Nix
expression language, a purely functional DSL used by Nix. And alongside the
software, it also configures it, effectively acting as a dotfile manager.
Indeed, many core NixOS services and a wide range of programs can be set up
through _NixOS modules_, where the program is installed and configured in the
same place. (and many programs like `fzf`, `btop`, etc have similar
corresponding `home-manager` modules).

NixOS is also _immutable_, which means that the system cannot be modified after
it is built from the Nix files that declare it. How do you make changes to the
system then? Obviously, we just create a new system where the changed programs
and files are included, and the old ones are removed. But they are not deleted
from the hard drive, they still exist in the _Nix store_. So, the system can
provide precise atomic rollbacks between each "generation" of itself. Broke
your GRUB configuration so your system won't boot? Messed up your kernel
settings? Just select an older working generation from the boot menu and you
instantly have a working system again. You never worry about breaking things
during either routine or massive system updates.

And because the system is fully declarative, and modifying the system is done
only through modifying its Nix configuration files,  you can version and sync
them up with Git. This solves the problem of keeping system environments in
sync; now, you truly only have to keep one repository of all your configuration
in sync, and all the software installation and deployment is handled for you by
a system designed precisely for that purpose.

This makes it possible for me to share common configuration between a multitude
of entirely distinct machines, including an `x86_64` desktop, an `x86_64`
laptop, an Apple Silicon Macbook running NixOS `aarch64` using [Asahi
Linux](https://asahilinux.org/), and the same Macbook running macOS with
`nix-darwin`, sharing `home-manager` configuration with NixOS. Specific
configuration necessary to adjust hardware-specific details between each
machines are isolated to the [hosts](./hosts) directory.

This works exceptionally well, evidenced by the fact that I have (almost) the
exact same environment across three separate machines, spanning two entirely
distinct CPU architectures.

In essence, the primary failure of deployment scripts, Ansible and the like is
that they are _imperative_ - they must specify precisely _how_ to set up the
system, down to minute details, whereas in a _declarative_ approach, the user
can simply specify what the system _should look like_, and abstractions take
care of the _how_. This is what NixOS does, and it gives you remote syncing,
versioning (via `git`), and rollbacks _for free_.


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

Non-exhaustive.

| Shortcut                                                                                                 | Action                           |
| -------------------------------------------------------------------------------------------------------- | -------------------------------- |
| <kbd>Super</kbd> + <kbd>W</kbd>                                                                          | Toggle floating                  |
| <kbd>Super</kbd> + <kbd>K</kbd>                                                                          | Toggle layout                    |
| <kbd>Super</kbd> + <kbd>E</kbd>                                                                          | Open Dolphin                     |
| <kbd>Super</kbd> + <kbd>T</kbd>                                                                          | Open kitty                       |
| <kbd>Super</kbd> + <kbd>F</kbd>                                                                          | Open librewolf                   |
| <kbd>Super</kbd> + <kbd>R</kbd>                                                                          | Open pavucontrol                 |
| <kbd>Super</kbd> + <kbd>Space</kbd>                                                                      | Open rofi                        |
| <kbd>Super</kbd> + <kbd>Backspace</kbd>                                                                  | Open logout menu                 |
| <kbd>Super</kbd> + <kbd>L</kbd>                                                                          | Screenshot region                |
| <kbd>Super</kbd> + <kbd>H</kbd><kbd>J</kbd><kbd>K</kbd><kbd>L</kbd>                                      | Move around                      |
| <kbd>Super</kbd> + <kbd>Ctrl</kbd> + <kbd>H</kbd><kbd>L</kbd>                                            | Move workspaces                  |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>Ctrl</kbd> + <kbd>H</kbd><kbd>J</kbd><kbd>K</kbd><kbd>L</kbd>   | Move windows around workspaces   |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>Ctrl</kbd> + <kbd>H</kbd><kbd>J</kbd><kbd>K</kbd><kbd>L</kbd> | Move windows around              |
| <kbd>Super</kbd> + <kbd>S</kbd>                                                                          | Open Special Workspace           |
| <kbd>Super</kbd> + <kbd>Enter</kbd>                                                                      | Fullscreen Window                |
| <kbd>Super</kbd> + <kbd>Alt</kbd> + <kbd>S</kbd>                                                         | Move Window to Special Workspace |
