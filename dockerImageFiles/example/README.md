OmpSs@FPGA Example Readme
=========================

This directory contains a basic implementation of the dotproduct kernel using FPGA tasks.

### Build

There are some steps to build the application: setup the environment, generate the bitstream, generate the boot files (depending on the board) and build the executables.
The example comes with a Makefile that allows easily building the bitstream (and boot) and executables.

##### Environment setup

The environment variables that we may need to set up for the compilation process are:
 * `CROSS_COMPILE` [Def: ""] Cross compiler prefix. The docker image has the tool-chain supporting:
   * `arm-linux-gnueabihf-` (ARM 32bits).
   * `aarch64-linux-gnu-` (ARM 64bits).
 * `MCC` [Def: `fpgacc`] Mercurium profile to compile the application.
 * `CFLAGS` [Def: `-O3`] Compiler flags.
 * `LDFLAGS` [Def: ""] Linker flags.
 * `PETALINUX_INSTALL` [Def: ""] Petalinux installation directory (only needed when building boot files)
 * `PETALINUX_BUILD` [Def: ""] Petalinux project directory (only needed when building boot files)

**NOTE: Do not source petalinux and/or vivado settings as they may break toolchain configuration.**

For example, we will set the following environment variables to build the example application for the Zedboard:

```bash
export CROSS_COMPILE=arm-linux-gnueabihf-
```

##### Bitstream

To generate the bitstream, we must enable the bitstream generation in the Mercurium compiler (using the `--bitstream-generation` flag) and provide it the FPGA linker (aka `ait`) flags with `-Wf` option.
In addition, we can use the `--instrument` option of Merciurim to enable the HW instrumentation generation.
The instrumentation can be generated and not used when running the application, but if we generate the bitstream without instrumentation support we will not be able to instrument the executions in the FPGA accelerators.

The Makefile has a target to build the bitstream for any board.
It enables the bitstream generation, instrumentation and SOM hardware runtime.
Then, we can just execute the following command to generate a first bitstream:

```bash
make bitstream BOARD=zedboard
```

Note that `ait` expects to have `vivado_hls` and `vivado` tools in the path.
Therefore, we need to add them to the `PATH` environment variable.
Assuming that Xilinx software version 2017.3 is available in `/opt/xilinx` folder, we can add them with the following command:

```bash
export PATH=$PATH:/opt/xilinx/Vivado/2017.3/bin
```

**NOTE: Do not source vivado settings as it may break the toolchain configuration.**

##### Boot Files

Some boards (like zcu102) do not support loading the bitstream into the FPGA after the boot, therefore we need to generate the boot files and update them before booting the board.
The Makefile has a target to build the boot once the bitstream has been created.
This step is not needed for the z7000 family of devices, as the bitstream can be loaded after boot.

To generate the boot, we need to have the `PETALINUX_INSTALL` and `PETALINUX_BUILD` environment variables appropriately set.
Then, we can run:

```bash
make boot BOARD=zcu102
```

##### Executables

The build target of the Makefile builds 3 versions of the application (and not the bitstream): performance, debug and instrumentation.
To generate them we have to execute:

```bash
make build
```

### Run

We should copy the files to the board and after that we can proceed with the following steps.
The files should include at least:
 * dotproduct.bin (bitstream).
 * dotproduct-d, dotproduct-i, dotproduct-p (executables).

##### Load the bitstream

Loading the new generated bitstream in the FPGA may be different depending on the board where we will run.
In the z7000 family of boards, we can do it with the following command available in the provided SD images:

```bash
load_bitstream dotproduct.bin
```

The ultrascale boards may require loading the bitstream during boot, so we need to update the boot files instead of executing the above commands.
We need to copy the `BOOT.BIN` and `ìmage.ub` files in the BOOT partition of the SD image.

##### Debug run

The debug version of the application runs using the Nanos++ debug version, which has sanity checks to avoid hangs or runtime crashes.
It is used like other binaries but some runtime options will provide more information (like `--summary`).

```bash
NX_ARGS="--summary" ./dotproduct-d
```

##### Performance run

The performance version of the application runs using the Nanos++ performance version, which avoids the debug checks.

```bash
./dotproduct-p
```

##### Instrumentation run

The instrumentation version of the application runs using the Nanos++ instrumentation version, which supports instrumenting the applications execution.
The extrae instrumentation plugin has been extended to support device instrumentation, so the runtime will gather information from the FPGA accelerators and add them to the usual extrae trace.

```bash
NX_ARGS="--instrumentation=extrae" ./dotproduct-i
```
