# Release 4.0.0-rc12
2023-01-19

* ait
  * Bump version to 6.4.1
    * Versioning now follows SemVer specification
  * Unified hardware runtimes into Picos OmpSs Manager (POM) v6.0
    * Supports all the features previously supported by Fast OmpSs Manager (FOM) and Smart OmpSs Manager (SOM)
    * Automatically detect required hwruntime features and enable them accordingly
    * Deprecated `--hwruntime` argument
  * Added `--interconnect_priorities` argument to enable priorities on memory interconnects
  * Added support for OmpSs@FPGA accelerator wrapper v13, which depends on the `new_task_spawner` IP
  * Added support for Vitis HLS
  * Internal refactor to follow Python packages structure in order to distribute AIT through PyPI
  * Several bug fixes and improvements
* mcxx
  * Implemented support for accelerator wrapper v13
  * Fixed `lock` field of AIT json to mark which accelerators use locking features
  * Added `needs_deps` field in AIT json to mark which accelerators have data dependencies
* nanox
  * Fixed configuration and installation on newer linux versions
  * Use xtasks multidevice API
  * Adapted data structures to accelerator wrapper v13
* xtasks
  * Bump version to 14.3
  * Added support for multiple FPGAs
  * Flipped `managed_reset` polarity
  * Fixed buffer overflow bugs
* xdma
  * Bump version to 4.2
  * Added support for multiple FPGAs
  * Renamed `euroexa_testbed2` backend to `euroexa_maxilink`
  * Split large copies into smaller chunks on `qdma` backend to avoid a kernel out-of-memory error
* Picos OmpSs Manager (POM)
  * Bump version to 6.0
  * Take into account current task in execution when optimizing data copies

### Release 3.3.1
2022-05-27

- ait
  - Bump version to 5.20
  - Check for invalid stride values when using memory interleaving feature
  - Compress IPs
  - Fix `euroexa_maxilink` and `euroexa_maxilink_quad` DDR part number
- xtasks
  - Bump version to 13.1
  - Fix bus error on arm64 when using qdma backend
- xdma
  - Bump version to 3.18
  - Fixed missing return status on qdma backend functions


### Release 3.3.0
2022-05-06

- ait
  - Bump version to 5.19
  - Updated bitInfo to v9
  - Added `--disable_spawn_queues` argument to disable the instantiation of HWR spawn queues
  - Added `--bitinfo_note` argument to add a user-defined note to the bitInfo
  - Added `euroexa_maxilink` and `euroexa_maxilink_quad` boards
  - Enabled over temperature automatic shutdown on all boards
  - Enabled bitstream compression
  - Set randomly generated `BITSTREAM_USERID` on compilation time to identify bitstream files
  - Generate .bit.bin file for Zynq7000 boards when possible
  - Fixed `zcu102` DDR DIMM configuration problem
  - Default number of Vivado jobs now depends on node's current available memory
  - Time is now formatted as human-readable
  - Improved error and information messages
  - Several bug fixes
- mcxx
  - Fix wideport memcpy functions on C code
- nanox
  - Modified FPGA lost events warning message
  - Added new paraver configs to generate histograms of FPGA events
  - General spell-checking
- xtasks
  - Bump version to 13.0
  - Dropped support for already deprecated `alpha_data` board
  - Updated bitInfo v9 device paths
- xdma
  - Bump version to 3.17
  - Fixed copies larger than 2GB
  - Correctly handle no DMA device operations available
- Kernel module
  - Updated module for kernel >5.xx
  - Dropped support for DMA devices on kernel >5.xx
  - Added devices to read new fields introduced in bitInfo v9

**Known issues**

- HWR only supports tasks with up to 15 arguments despite xTasks supports 30


### Release 3.2.0
2021-12-22

- mcxx
  - Changed accelerator HLS source file name
  - Refactor accelerator json info file

- ait
  - Bump version to 5.8
  - Implement interleaved memory access
  - Simplified DDR interconnection
  - Accelerator floorplanning
  - Change clock source from DDR0 to QDMA in alveo devices

**Known issues**

- HWR only supports tasks with up to 15 arguments despite xTasks supports 30

### Release 3.1.0
2021-09-22

- ait
  - Bump version to 5.3
  - Fix boot step for petalinux 2018.3
  - BitInfo BRAM is now writeable
  - Parse accelerator information from JSON file
  - [EuroEXA] Add support for CRDB using maxilink communications
- mcxx
  - Allow variables on num_instances pragma. Value must be known at compile time
  - Store accelerator information in JSON file
- xdma
  - Bump version to 3.16
- xtasks
  - Bump version to 11.1
  - Fix cross compiling to x86-64
- Docker image
  - Upgrade docker base image to debian 11 bullseye
  - Update docker image libraries (libxml, papi, binutils)
  - Fix building x86-64 as a cross compiler
  - Implement multistage docker image building
  - Pull libxml though http instead of ftp
  - Fix environment file
- Extrae
  - Upgrade to 3.8.3
- Kernel module
  - Fix CDMA transfers when the end of the buffer was aligned to a page

**Known issues**

- HWR only supports tasks with up to 15 arguments despite xTasks supports 30


### Release 3.0.1
2021-06-18

- Fix compiler error in euroexa crdb xdma backend


### Release 3.0.0
2021-06-14

- Refactor HWR <-> FPGA task accelerators interconnection layout
- General refactor of HWR internals
- Install extra packages in docker image needed by new petalinux versions
- ait
  - Bump version to 5.0
  - Updated SOM to v4.5
  - Added POM v4.7
  - Removed support for AXI-Stream communication backend
  - Removed 16 accelerator limit
  - Removed --interconnect_level argument
  - Refactored info, warning and error messages
  - Move default IP cache location to /var/tmp/ait
  - Several bug fixes and minor improvements
  - Add option --hwruntime_interconnect to select the communication strategy between HWR <-> FPGA task accelerators
- xTasks
  - Bump version to 11.0
  - Support for wrapper versions 5 to 12 (but requires bitinfo v8)
  - Removed stream back-ends
  - Automatically create libxtasks.so link during install
  - Remove xtasksWaitTask API
  - Dynamically allocate the communication queues to support N accelerators
  - Support for bitinfo v8 and parsing non-ASCII xtasks config
- mcxx
  - Add fpga -directive- data -pack option to control the placement of DATA-PACK directive in FPGA wrappers
  - Update HWR ids according to new FPGA interconnect design
  - Set default value of fpga -unordered- args to false
  - Remove accelerator id port from FPGA wrapper
- nanos
  - Fix FPGA instrumentation handling when there are multiple point events of key EventsLost
  - Add a sanity-check in debug mode for reverse offloaded tasks
- xdma
  - Bump version to 3.14
  - Fix offset precision issue when managing large memory regions
  - Add XDMA-DEV-MEM_SIZE environment variable to define the size of device memory pool
  - Improve README for qdma and crdb backends

**Known issues**

- [AIT] Generation of boot files fails for Petalinux 2018.3
- HWR only supports tasks with up to 15 arguments despite xTasks supports 30

### Release 2.5.2
2021-03-03

- Fix parsing of AIT IP_cache_location argument
- Add minimum Vivado version check during AIT calls

### Release 2.5.1
2021-02-23

- Fix AIT submodule remote ref
- Fix mcxx installation structure in Docker

### Release 2.5.0
2021-02-19

- New installation structure in /opt/bsc/
- AIT
  - Version 3.19
  - Added argument --debug_intfs to automatically generate debug probes
  - Added argument --interconect_regslice to enable register slices on AXI interconnects
  - Increased max supported DDR connections
  - Updated SOM to 3.7
  - [MEEP] Added support for Alveo U280 board
  - [EuroEXA] Added support for VU9 testbed 2
  - [Picos] Added arguments to modify Picos parameters
  - [Picos] Updated POM to 3.7
- xTasks
  - Bump version to 9.20
  - Support for wrapper version v12
  - Improve instrumentation event invalidation mechanism
- mcxx
  - Changed how intermediate hls files are treated
    - now they are automatically overwritten
    - same fashion as usual .o files
  - Unify input streams of FPGA task accelerators
  - Add option --variable=fpga_check_limits_memory_port to remove the limit checking during the memport data retrievement
  - Add option --variable=fpga_unordered_args to remove the switch case that allows handling the arguments out-of-order
- nanos
  - Fix taskwait on implementation
- xdma
  - Bump version to 3.11
  - Remove QDMA dependencies
  - Minor code cleanup and improvements
- SD image
  - Fix permissions not being correctly set to the clock and FPGA and clock reconfiguration device files
  - Fix kernel module not being automatically loaded
  - Fix fallback FSBL flag file not being removed on successful boot
  - New installation paths

**Known issues**
- CommandIn manager only supports tasks with up to 15 arguments despite xTasks supports 30

### Release 2.4.0
2020-11-06

- Deprecation of stream backend (the support will be removed in next release)
- Added x86 toolchain installation in Docker image
- Added support for `nanos_fpga_get_time_cycle` and `nanos_fpga_get_time_us` APIs inside FPGA task accelerators
- AIT
  - Version 3.11
  - Update Vivado version of board templates
  - Added support for `alveo_u250` board
  - SOM hardware runtime version 3.3 with extended support for internal task creation
- xTasks library
  - Version 9.17
  - General improvements and minor fixes
  - Implemented periodic tasks API for qdma devices
  - Add support for `XTASKS_PCIDEV_ENV` environment variable to select the desired PCI device
- XDMA library
  - Version 3.10
  - Add support for `XDMA_QDMA_DEV` environment variable to select the desired QDMA device
- OmpSs@FPGA Zynq Kernel Module
  - Added support for device memory interaction
  - Added support for write operation in bitinfo/raw device

**Known issues**
- CommandIn manager only supports tasks with up to 15 arguments despite xTasks supports 30

### Release 2.3.0
2020-09-30

- Added support for critical OmpSs directive between FPGA task accelerators
- FSBL fallback sentinel file is correctly removed upon successful boot
- ait
  - AIT version 3.8
  - POM hardware runtime version 3.2
    - Full new implementation based on SystemVerilog
    - Fix bug with nested FPGA tasks
    - Fix bug with several tasks finishing at the same time
  - SOM hardware runtime version 3.2
    - Full new implementation based on SystemVerilog
  - Restructure AIT resources file reports and create timing-impl.txt report
  - Add URAM to resource utilization reports
  - Optimized interconnection net to reduce resource utilization and improve timing
  - Fix BOOT generation with new Petalinux versions
  - Experimental support for alveo u200/qdma device
  - Fixes in installation scripts and project name check
  - Generate clock design using a clock wizard
  - Remove support for trenz board
- xTasks
  - Fix return value of some APIs
  - Experimental support for alveo u200/qdma device
  - Initial support for euroexa testbed platform
  - Fix error when some periodic tasks are sent to cmdIn queue
  - Support for wrapper version 10
- mcxx
  - Pull upstream repo changes
  - Add compiler option (fpga_unaligned_memory_port) to support unaligned data movements in the FPGA
  - Add compiler option (fpga_ignore_deps_task_spawn) to ignore task dependences when spawning tasks inside another FPGA task
  - Fix taskwait inside FPGA devices under some circumstances
  - Add support for critical regions inside FPGA task accelerators
  - Add support for usleep calls inside FPGA task accelerators
  - Unify output stream ports into a single hand-shake port
  - Fix problems with import of some functions into the HLS intermediate files
  - Add support for new instrumentation events in FPGA wrapper APIs:
    - taskwait
    - lock set/unset/tryset
  - FPGA wrapper version 10
- nanos
  - Pull upstream repo changes
  - Add --throttle-depth option to hysteresis plugin
  - Add support for new FPGA events generated in the wrapper API calls
- xdma
  - Fix problem with concurrent calls to xdmaMemcpy in alpha_data back-end
  - Add support for cdma for euroexa testbed platform
- kernel module
  - Add support for new bitinfo/base_freq field
  - Fix problem with xdma_cleanup

**Known issues**
- CommandIn manager only supports tasks with up to 15 arguments despite xTasks supports 30

### Release 2.2.0
2020-04-24
- Install python3 in docker image
- ait
  - Ported AIT to Python3. Deprecated support for Python2 execution
  - Added AIT argument to instantiate a hardware counter on the bitstream
  - Added post-implementation resource utilization report
  - Added post-implementation timing report
  - AIT version 2.25
  - Update SOM to version 2.1
  - **Picos** hwruntime is no longer supported
  - Added support for Euroexa Alveo testbed board
  - Added **Picos OmpSs Manager (POM)** hwruntime (v1.2)
- mcxx
  - Fix mcxx_ptr declarations with non-basic types and digraphs names
  - Fix problem with some declarations of periodic API in C
  - Avoid unroll of outer loop in when shared memory port is enabled
  - Update FPGA task creation interface to support new POM hwruntime
  - Do not try to move class member functions to HLS sources
- xtasks
  - Removal of libpicos back-end
  - Add support for FPGA wrapper version 6
  - Re-order deps-copies-args of FPGA spawned tasks (wrapper version 5)
  - Fix alignment issues in some cases for internal structs
  - libxtasks version 9.2
- xdma
  - Fix problem with memcpy SIGSEGV in some unaligned data movements
  - Split DMA write transaction into multiple smaller transactions in alpha_data back-end
  - libxdma version 3.3

**Known issues**
- Vivado crashes when generating a design with DMAs for the Trenz board
- FSBL fallback sentinel file is not removed upon successful boot (see [releases#9](https://pm.bsc.es/gitlab/ompss-at-fpga/ompss-at-fpga-releases/issues/9))
  - Also see <https://pm.bsc.es/ftp/ompss-at-fpga/doc/user-guide/fsbl-fallback.html#system-cleanup-service>
- The option `fpga_memory_port_width` of mcxx wrongly handle unaligned regions and output regions which size is not multiple of the port width.

### Release 2.1.2
2020-04-22
- Fix AIT design step which was not containing any accelerators

**Known issues**
- Vivado crashes when generating a design with DMAs for the Trenz board
- FSBL fallback sentinel file is not removed upon successful boot (see [releases#9](https://pm.bsc.es/gitlab/ompss-at-fpga/ompss-at-fpga-releases/issues/9))
  - Also see <https://pm.bsc.es/ftp/ompss-at-fpga/doc/user-guide/fsbl-fallback.html#system-cleanup-service>


### Release 2.1.1
2020-03-18
- Fix AIT issue checking for board support and setting board files in Vivado backend
- Fix generation of xtasks.config file
- Fix partition table for ultrascale that fixes boot in some board revisions
- Change zynq ultrascale hostname from bsc-trenz to bsc-zynqmp
- Add load_bitstream script to the ultrascale SD image
- Remove stale openblas installation in SD images

**Known issues**
- Vivado crashes when generating a design with DMAs for the Trenz board
- FSBL fallback sentinel file is not removed upon successful boot (see [releases#9](https://pm.bsc.es/gitlab/ompss-at-fpga/ompss-at-fpga-releases/issues/9))
  - Also see <https://pm.bsc.es/ftp/ompss-at-fpga/doc/user-guide/fsbl-fallback.html#system-cleanup-service>


### Release 2.1.0
2020-02-18
- New Nanos++ FPGA APIs to support creation+submission of FPGA tasks directly from user code.
- Add calls to Nanos++ creation+submission APIs in the SMP outline functions of FPGA tasks.
- New accelerator wrapper version (v3) with periodic tasks support (experimental feature).
- Fix compilation problems with memcpy calls inside FPGA tasks under some circumstances.
- Auto-enable 64bit memport on FPGA accels with task creation capabilities.
- Fix alpha_data instrumentation issue.
- Fix `--user_constraints --user_pre_design --user_post_design` AIT options.
- Fix AIT failure when not specifying wrapper version.
- Add hwruntime version to bitInfo (version >= 5).
- Add device `/dev/ompss_fpga/bit_info/hwruntime_vlnv` to read hwruntime version from bitInfo.
- Fix failure with Ikergune board on Vivado 2018.3 and newer versions.
- Added AIT option to limit the number of jobs that Vivado creates.
- Fix perf in Zynq7000 SD image.
- Fix round-robin policy of SOM/Scheduler IP.

**Known issues**
- Vivado crashes when generating a design with DMAs for the Trenz board


### Release 2.0.0
2020-01-30
- Introducing AIT (formerly autoVivado).
  - Refactored tool to abstract itself from the vendor backend so different toolchains can be used.
  - Automatically integrate available hardware runtimes into FPGA designs.
  - Updated bitstreamInfo BRAM to version 4.
  - Added option to use user-defined constraints and pre- and post-design scripts.
  - Added option to skip board support check.
  - Added support for the COM Express Xilinx-based board.
  - General bug fixes and improvements.
- Introducing SOM hardware runtime in replacement of Task Manager.
  - Based on general commands instead of tasks.
  - Designed using optional modules which are removed if no needed.
- General improvements in FPGA phase of Mercurium.
  - Support for `#pragma omp target device(fpga)` directives over constant variables declarations.
  - Automatically copy of functions called inside a FPGA task to the HLS intermediate file (only inside the same TU).
  - Add support for calling the same function from different FPGA tasks without putting it in a `.fpga` header file.
  - Introduce FPGA wrapper versioning.
  - Enhance support for FPGA spawned tasks and its parents.
  - Use external adapter for HW instrumentation (reduces the resources consumption).
  - Clarify license in header of HLS intermediate files.
  - Automatically add the `disable_final_clause_transformation:1` option in FPGA profiles.
- Fix problem when unloading and loading kernel module several times.
- Restructure/rename devices in the kernel module to adapt to new tool names.
- General improvements in FPGA architecture of Nanos++.
  - Fix default hysteresis throttle policy.
  - Refactor of HW instrumentation to use a pooling model instead of synchronizing it after each task execution.
  - Update FPGA API to improve the support of fpga spawned tasks.
  - Increase default FPGA allocator size to 512MB.
  - Fixes and improvements in the cache structures.
- Robustness enhancement of xTasks library.
  - Re-implement xTasks backends to use the commands interface of SOM.
  - Check the compatibility of loaded bitstream during initialization.
  - Check that loaded bitstream has the features required by the backend.
  - Add environment variables to tune the xTasks behavior: `XTASKS_FEATURES_CHECK`, `XTASKS_RESET_POLARITY`, `XTASKS_COMPATIBILITY_CHECK`.
  - Improve the support of `alpha_data` board.
- Improve the support of `alpha_data` board in XDMA library.

### Release 1.4.3
2019-12-19
- Clarify license of intermediate HLS files generated by Mercurium.
- autoVivado licensing update

### Release 1.4.2
2019-09-25
- Fix petalinux settings source during BOOT step on complex environments.

### Release 1.4.1
2019-09-23
- Fix PS configuration in revision 1.1 of ZCU102.
- Fix HW instrumentation problems in some Vivado versions (>= 2018).

### Release 1.4.0
2019-09-16
- Fixed bitstreamInfo on OberonX template.
- Fix problem in autoVivado during BOOT step with the init scripts.
- Correct execution path of synthesis scripts to avoid problems with Vivado HLS Analysis perspective.
- Install FPGA paraver configs in NANOX_INSTALL_DIR/share/doc/nanox/paraver_configs/ompss/fpga.
- Avoid some non-critical errors and undesirable crashes in kernel module.
- Support **__HLS_AUTOMATIC_MCXX__** preprocessor define inside fpga accelerator tasks to know when the task code is being synthesized.

### Release 1.3.2
2019-05-30
- Fix autoVivado execution problems on systems without python support in binfmt_misc.
- Fix soft-link creation during some autoVivado steps resulting in a non-fatal error.
- Remove xdma mmap failed error print as this situation in handled by Nanos++.

### Release 1.3.1
2019-05-17
- Increase default FPGA memory allocator size to 512MB in Nanos++.
- Fix Mercurium crash when no output file was provided.
- Fix wrong information being shown in bitstream information devices after bitstream reloading.
- Improvements in autoVivado installation process.

### Release 1.3.0
2019-05-14
- Replace taskmanager and xdma device drivers by OmpSs@FPGA kernel module.
  - New devices to see the available bitstream features.
  - Restructure the previous devices based on responsibilities.
- Fix kernel memory allocation and free in 2018.3/kernel 4.14.
- Fix only one accelerator being able to emit instrumentation events when using multiple accelerators.
- Fix problem with unaligned memcpy in some 64 architectures.
- New autoVivado features:
  - Add --interconnection_level option to define the accelerators interconnection mode.
  - Add --ignore_eng_sample option to ignore the 'engineering sample' status of board part number.
  - Add --verbose_info option to increase the verbosity without printing vivado and vivado_hls logs.
  - Generate BRAM with bitstream information.
  - Add new Task Manager IPs in the extended mode to support remote task execution and internal FPGA task scheduling.
  - Propagate TM reset signal to accelerators.
  - Improvements of help information.
  - Restructure board dependent source code.
  - Several other minor improvements and fixes.
- Fix fibbfd detection in aarm64 machines when configuring Extrae.
- Mercurium changes:
  - Merge changes from main Mercurium repo.
  - Automatically add the --name option when invoking autoVivado.
  - Only show onto clause warning once.
  - Avoid FPGA accelerator localmem feature over VLAs.
  - Simplify FPGA wrapper localmem generation without considering the copies direction (always create inout wrapper code).
  - Add support for localmem when data is const.
  - Fix movement of called functions to fpga source code
    - KNOWN ISSUE: Each symbol can only be called from 1 fpga accelerator.
  - Improve fpga task spawn code generation.
  - Add fpga_memory_port_width variable to enable the creation of a shared memory port for all task arguments with the specified bit-width.
  - Other minor fixes.
- Nanox changes:
  - Fix data type mismatch of fpga spawned task in 32 bits platforms.
  - Add copies handling in fpga spawned task.
- Changes in xdma:
  - Add new APIs: xdmaInitMem() and xdmaFiniMem().
  - Fix internal blocking flags wrongly defined in xdmaStream() API call.
  - Source code restructuring to support platforms different than Zynq.
  - Remove linux kernel driver source code.
- Changes in xtasks:
  - Adapt the library initialization based on available bitstream features.
  - Improve some error messages.
  - Improve instrumentation code.

### Release 1.2.3
2019-02-15
- Fix accelerators not setting last event type as last.
- Fix bogus warning regarding device instrumentation.
- Add perf to SD images.

### Release 1.2.2
2019-02-07
- Temporarily disable FPGA task creation capabilities in Nanos++ to avoid undefined symbol when fpga support is not enabled.
- Fix WD type generation in mcxx when a task is called from multiple locations.

### Release 1.2.1
2019-01-09
- Emit a warning when hardware instrumentation events are lost.
- Fix allocating unaligned kernel memory when the user manually allocates certain sizes.

### Release 1.2.0
2018-12-12
- Support for `oberonx` board.
- autoVivado licensing update.
- Support for `zybo` boards on rootfs.
   - Added bootfiles and kernel modules.

### Release 1.1.0
2018-11-28
- Support for `zybo` board.
- Minor fixes in autoVivado.
- Do not initialize the fpga instrumentation in performance and debug versions.
- Use `void *` in fpga alloc APIs instead of `nanos_fpga_alloc_t`.
- Fix a segfault in libxtasks-taskmanager when there is no instrumentation HW.

### Release 1.0.0
2018-11-16
- Version-less autoVivado templates.
- Fix trenz board constraints.
- Add `--extended_tm` option in autoVivado.
- Add support for user-defined FPGA instrumentation events.
  - APIs supported in the FPGA code are:
    - `nanos_err_t nanos_instrument_burst_begin(nanos_event_key_t key, nanos_event_value_t value)`.
    - `nanos_err_t nanos_instrument_burst_end(nanos_event_key_t key, nanos_event_value_t value)`.
    - `nanos_err_t nanos_instrument_point_event(nanos_event_key_t key, nanos_event_value_t value)`.
  - In the host side the following API may be used to register the keys emitted by fpga code:
    - `nanos_err_t nanos_instrument_register_key_with_key(nanos_event_key_t event_key, const char *key, const char *description, bool abort_when_registered)`.
  - New option in Nanos++ to define the number of fpga events that a task should support:
    - `--fpga-max-instr-events` in `NX_ARGS`.
    - `FPGA_MAX_INSTR_EVENTS` environment variable.
- Fixed problem with const arguments in FPGA tasks.
- Change `acc_num` field of `nanos_fpga_args_t` by `type`.
- New APIs for fpga memory allocation and management:
  - `nanos_fpga_malloc`.
  - `nanos_fpga_free`.
  - `nanos_fpga_memcpy`.
  - This change includes the deprecation of `nanos_fpga_alloc_dma_mem` and `nanos_fpga_free_dma_mem`.
- Nanos++ only depends on libxtasks. Option `--with-xdma` in configure has been removed.
- New libxtasks API to support memory allocation.
- New libxdma API to support non-shared memory devices.

### Release 0.3.3
2018-10-29
- Fixes a problem in the Docker image that prevents the correct setup of the environment (tools not available in the PATH).
- Updates the pre-build examples in the SD images to be compiled with the newest mcxx version.

### Release 0.3.2
2018-10-05
- Mercurium fix to correctly generate the HW code to retrieve scalar parameters.

### Release 0.3.1
2018-10-02
- Fixes and improvements on some README(s).
- Fixes a problem when launching Vivado HLS in graphical mode inside the container.
- Includes Paraver installation.

### Release 0.3.0
2018-10-02
- Update of all components.
- Update of SD images.
