Docker Image Readme
===================

This docker image contains and pre-configured environment to build OmpSs@FPGA applications targeting Xilinx Zynq 7000 and Zynq Ultrascale+ devices and the following architectures:
 * ARM 32bits (arm-linux-gnueabihf)
 * ARM 64bits (aarch64-linux-gnu)
 * x86_64 (x86_64-linux-gnu)

### Prerequisites
 * Docker
 * Xilinx Vivado (recommended 2017.X or higher)
 * Vivado license for the target device
 * [Optional for BOOT.BIN generation] Petalinux


### General information

The image contains different Mercurium installations to cross-compile applications for each architecture.
In addition, it contains the required libraries, which the applications will be linked against, in the `/opt/install-XXXX` folder.
These libraries are also installed in the same paths in the SD-Images.

The image **does not contain** an installation of Xilinx tools (like VivadoHLS or Vivado), neither an installation petalinux tools or a build of a petalinux project.
These tools will be needed to generate the board bitstreams and/or generate the boot files.
The next sections show how to use the host installation of these tools inside the container.

The default image user is `ompss`, and its password is `ompss`.

### Usage

NOTE: The following steps and commands assume that you downloaded the `unknwn` version of the docker image.
You may need to modify the commands to fit the version you downloaded.
In addition, some of the following commands may require superuser privileges depending on you docker installation.
See Docker documentation for more information about privileges.

#### Load docker image

The first step to use the docker image is loading it in your machine.
It is done with the following command:

```bash
docker image load -i ompss_at_fpga_unknwn.tar
```

#### Run the container

After the image has been successfully loaded, we are ready to run a container.
We have to specify some options through the command line in order to correctly set up the environment.
Usually, you will need to map the folders where you have the Xilinx tools installed and maybe the petalinux tools and build.
Moreover, you may need to add the folder where your application source code is.
Assuming that you have the Xilinx tools in `/opt/xilinx`, the petalinux stuff in `/opt/petalinux` and the application source in your home, the docker run command will be similar to the following:

```bash
docker run -it \
	-v /opt/xilinx/:/opt/xilinx/ \
	-v /opt/petalinux/:/opt/petalinux/ \
	-v $HOME:$HOME \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /media/:/media/ \
	-e DISPLAY=$DISPLAY \
	--network host \
	ompss_at_fpga:unknwn bash
```

NOTE: In order for Xilinx tools and petalinux to run correctly, paths inside the container should be the same as installation path.

###### Docker run options

 * `-v host_directory:container_directory`
   * Binds a directory in the host into the container
 * `-v /tmp/.X11-unix:/tmp/.X11-unix`
   * Display server resources available in the container
 * -e DISPLAY=DISPLAY
   * Set the DISPLAY environment variable
 * --network host
   * Set the container network
 * `--rm`
   * Remove the created container after it exits

#### Attach to the container

Once the container has been run, you can attach to it anytime using its container ID or name.
Container ID can be obtained by running:

```bash
docker ps -a
```

This should result in something like the following output:

```bash
9fbf23073429        ompss_at_fpga:unknwn        "bash"              3 weeks ago         Exited (0)
```

Then you can attach to it and continue working by running:

```bash
docker start -i -a 9fbf23073429
```

#### Remove docker image

Once you finished using the docker image, you can delete it with the following command:

```bash
docker rmi ompss_at_fpga:unknwn
```

NOTE: You cannot delete the docker image if there are containers of this image.
First you will need to remove the docker containers with `docker rm` command.
