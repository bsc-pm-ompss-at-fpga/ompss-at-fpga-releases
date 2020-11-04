In order to boot, BOOT.BIN and image.ub must be placed in the boot partition root directory.
Copy the boot files from the directory corresponding to your board into the root directory in order to boot.

Needed files are:
 * BOOT.BIN
   It contains bootloader files as well as the FPGA bitstream.
 * image.ub
  It contains the linux kernel image and the device tree.

Example boot files are included for different boards.
The provided boot files contain the bitstream of the dot product example and it can be used to test the environment.
