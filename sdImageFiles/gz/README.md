SD Images Readme
================

## Prerequisites

A linux system with
 * dd (part of coreutils)
 * gzip
 * An SD card (Class 10 is recommended)
   * 8GB card for zynq ultrascale
   * 4GB for zynq 7000 devices
 * udisks2 (for reading image contents)

## General information

The default user is `ubuntu`, and its password is `ubuntu`.

## Dumping the image file into an SD card

The compressed image file can be written to the SD card in a single step

```bash
gunzip <ultrascale_sd_unknwn.img.gz | dd of=/dev/mmcblk0 bs=4M status=progress
```

Also, an uncompressed image can be written to the SD
```bash
dd if=ultrascale_sd_unknwn.img of=/dev/mmcblk0 bs=4M status=progress
```

### Setting up boot files

In order to boot, BOOT.BIN and image.ub must be placed in the boot partition root directory.
Copy the boot files from the directory corresponding to your board into the root directory in order to boot.

Needed files are:
 * BOOT.BIN   
   It contains bootloader files as well as the FPGA bitstream.
 * image.ub   
   It contains the linux kernel image and the device tree.

Example boot files are included for different boards.
The provided boot files contain the bitstream of the dot product example and it can be used to test the environment.

## Mounting image contents

Instead of writing its contents to a physical card, filesystem contents can be mounted.

Image file must be uncompressed
```bash
gunzip ultrascale_sd_unknwn.img.gz
```

Then, image can be mounted using udisksctl tool

Setup the loop device:
```bash
udisksctl loop-setup -f ultrascale_sd_unknwn.img
```

This will create a loop device in the form of `/dev/loop0pX` where `X` is the partition index.
In our case, there are 2 partitions boot (index 1) and rootfs (index 2).

This devices can be directly mounted:

```bash
udisksctl mount -b /dev/loop0p2
```

### Unmount an image

Images must be unmounted through udisksctl:

```bash
udisksctl unmount -b /dev/loop0p2
```

Then the loop device can be deleted:
```bash
udisksctl loop-delete -b /dev/loop0
```
