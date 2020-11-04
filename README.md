# OmpSs@FPGA releases

This meta-repository contains the official OmpSs@FPGA releases.

This repository uses submodules to link against the different OmpSs@FPGA tools. To download all the submodules when clonning this repository, you might use:
```
git clone --recursive https://gitlab.bsc.es/ompss-at-fpga/ompss-at-fpga-releases.git
```
To obtain further information about each tool, visit the README of each tool or visit the [OmpSs@FPGA Wiki](https://pm.bsc.es/gitlab/ompss-at-fpga/wiki).


### Build docker image

To build the docker image, you just need to recurisvely clone and the repository and recursively checkout the desired version.
After that, you might run the following docker command in the root repository directory (to create the `ompss_at_fpga` docker image with the `unknwn` tag):
```bash
docker build --squash -t "ompss_at_fpga:unknwn" --force-rm .
```

NOTES:
 - The `--squash` option creates a final image without the intermediate build layers. This creates a smaller but less modular image.  
   This option requires the `--experimental` option in the docker daemon, see [docker build Reference Manual](https://docs.docker.com/engine/reference/commandline/#squash-an-images-layers---squash-experimental).
 - The `--force-rm` option removes the intermediate layers after build.
