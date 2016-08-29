# NixOS on Yoga 900

## Purpose

This repository will provide instructions and configuration to setup your
Yoga 900 2-in-1 laptop.

It will contain manual and unassisted installation instructions separately
so that people can understand what is happening during the unassisted
installation script.

## Prerequisites

* A Yoga 900 tablet you want to install NixOS on by blowing away the Windows
  partition.
* A USB drive to boot NixOS boot installer image from.
* A USB to RJ45 adapter
* Physical network link/cable connected to Internet.

## Scope

* These instructions use the latest stable NixOS 16.03 minimal install image
* We update the `nixos` root channel to a newer NixOS 16.09pre version before
  `nixos-install`.
* The `configuration.nix` provided will offer you a working (though minimal)
  NixOS configuration with the following hardware verified:
  * Wireless internet card working
  * Webcam working
  * Touchscreen
  * Touchpad
  * Reasonable power management defaults using TLP service.

## Recommendations

If there are BIOS or firmware updates available for your Yoga 900 available
from Lenovo or Microsoft, please download them and install them via your
Windows 10 partition that came with your laptop.

## Manual Instructions

1. Download and prepare a NixOS minimal 64-bit installer ISO from:
   https://nixos.org/nixos/download.html under the linked with anchor
   text _'Minimal installaction CD, 64-bit Intel/AMD'_. After download
   make sure you verify the downloaded file's SHA-256 with the one at
   the link under the anchor text 'SHA-256' ajacent to prior link.
2. Write the image to a USB drive you are happy wiping contents from.
   On Linux or OS X you can do this with the command:
   `sudo dd bs=4M if=path/to/nixos-minimal-15.09.Y.Z-x86_64-linux.iso of=/dev/sdX`
   where `X` is the letter of the device on the system you are creating
   the bootable USB installer from.
3. Ensure your Yoga 900 is in a powered off state.
4. On the right hand side of your Yoga 900 there is a small penpoint button
   between two externally obtruding buttons. Use a pencil or stylus tip to
   press the round penpoint button and wait for the BIOS menu, select an
   option titled 'Boot menu' (or similar, third one down on mine).
5. Select the USB drive to boot from in the boot media menu screen.
6. Once the bootable USB loads the root command prompt run the following
   commands:

```bash
$ fdisk -l /dev/sda
Disk /dev/sda: 477 GiB, 512110190592 bytes, 1000215216 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: ???

Device         Start        End   Sectors   Size Type
/dev/sda1       2048     206847    204800   100M EFI System
/dev/sda2     206848     239615     32768    16M Microsoft reserved
/dev/sda3     239616  997105663 996866048 475.4G Windows ???
/dev/sda4  997105664  998641663   1536000   750M Windows recovery environment
/dev/sda5  998641664 1000214527   1572864   768M Lenovo boot partition
```

   You will see that the third partition (`/dev/sda3`) has Windows data on it.
   Assuming you want to erase that partition (if you don't, this repository is
   not for you and you should abort immediately) then you should delete the
   partition, create a new Linux filesystem partition across the same sectors
   and write the changes to the partition table.

   To do this:

```bash
TODO: parted commands here
```

7. Encrypt `/dev/sda3` and mount necessary partitions to prepare for
   installation like so:

```bash
$ cryptsetup luksFormat /dev/sda3
$ cryptsetup luksOpen /dev/sda3 nixosroot
$ mkfs.ext4 /dev/mapper/nixosroot
$ mount /dev/mapper/nixosroot /mnt
$ mount /dev/sda1 /mnt/boot
```

8. Setup `/mnt/etc/nixos` dir as in `etc/nixos` dir in  repo for Yoga 900
   hardware. This has been tested on my Yoga 900-13ISK. See
   [etc/nixos](etc/nixos). You can just edit [vars.nix](etc/nixos/vars.nix)
   with your overrides. I have not included my slim/xmonad configuration
   here, so you should add your own X customizations.

9. Update the root Nix channel for `nixos` with the latest 16.09pre release.
   I used the following:

```bash
$ nix-channel -add http://nixos.org/releases/nixos/unstable/nixos-16.09pre89269.8512747 nixos
```

10. Build NixOS configuration for your Yoga 900 with: `nixos-install`

11. Enjoy your new Yoga 900 with NixOS installed.

TODO: Write automated scripts to systemize.
