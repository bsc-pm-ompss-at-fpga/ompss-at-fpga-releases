ARG DEBIAN_FRONTEND="noninteractive"
ARG INSTALLATION_PREFIX=/opt/bsc
ARG BUILD_ONLY
ARG RELEASE_TAG

FROM ubuntu:18.04 AS base
ARG INSTALLATION_PREFIX
ARG RELEASE_TAG
LABEL AUTHOR="Programming Models Group at BSC <ompss-fpga-support@bsc.es> (https://pm.bsc.es/ompss-at-fpga)"
#ARG INSTALLATION_PREFIX
RUN  apt update && apt install -y autoconf \
        automake \
        binutils-dev \
        bison \
        build-essential \
        ca-certificates \
        curl \
        flex \
        gfortran \
        gperf \
        git \
        libboost-all-dev \
        libiberty-dev \
        libltdl-dev \
        libsqlite3-dev \
        libtool \
        libxml2-dev \
        pkg-config \
        python \
        python3.7 \
        python3-pip \
        sudo \
        vim \
        wget \
# Needed by Xilinx tools
        libgtk2.0-0 \
        libncurses5 \
        libx11-6 \
        libxext6 \
        libxrender1 \
        libxtst6 \
        procps \
# Needed by Petalinux tools
        bc \
        chrpath \
        cpio \
        diffstat \
        gawk \
        gnupg \
        gnupg-agent \
        libncurses5-dev \
        libtool-bin \
        locales \
        lsb-release \
        net-tools \
        rsync \
        socat \
        texinfo \
        unzip \
        xterm \
        zlib1g-dev \
# Extra tools
	openssh-client

RUN python3.7 -m pip install pip --upgrade
RUN python3.7 -m pip install wheel --upgrade
RUN python3.7 -m pip install setuptools --upgrade

# Install and configure tzdata
RUN export DEBIAN_FRONTEND=noninteractive; \
    export DEBCONF_NONINTERACTIVE_SEEN=true; \
    echo 'tzdata tzdata/Areas select Etc' | debconf-set-selections; \
    echo 'tzdata tzdata/Zones/Etc select UTC' | debconf-set-selections; \
    apt-get install --no-install-recommends tzdata


#if is arm64

RUN if [ \"`arch`\" = \"aarch64\" ] || [ \"`arch`\" = \"arm64\" ] ; then  \
        dpkg --add-architecture amd64 && apt-get update  && apt-get install -y\
        crossbuild-essential-amd64 \
        gfortran-x86-64-linux-gnu \
        g++-multilib-x86-64-linux-gnu \
        gcc-multilib-x86-64-linux-gnu ; \
    elif [ \"`arch`\" = \"x86_64\" ]; then \
        apt-get install -y \
        crossbuild-essential-arm64 \
        gfortran-aarch64-linux-gnu; \
    else \
        false; \
    fi;


RUN apt-get update \
 && apt-get install -y -q \
        crossbuild-essential-armhf \
        gfortran-arm-linux-gnueabihf

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && locale-gen \
 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

FROM base as installed_pkg
FROM installed_pkg as build
ARG INSTALLATION_PREFIX
ARG RELEASE_TAG

WORKDIR /tmp/work/



#INSTALL PAPI

ENV CFLAGS=-Wno-format-truncation
ENV CXXFLAGS=-Wno-format-truncation


RUN wget http://icl.utk.edu/projects/papi/downloads/papi-6.0.0.tar.gz && tar -zxf papi-6.0.0.tar.gz  && rm papi-6.0.0.tar.gz


WORKDIR /tmp/work/papi-6.0.0/src

#ARM64
RUN ./configure --prefix=$INSTALLATION_PREFIX/arm64/papi --host=aarch64-linux-gnu --with-arch=aarch64 \
    --with-CPU=arm --with-ffsll --with-walltimer=cycle -with-tls=__thread \
    --with-virtualtimer=perfctr --with-perf-events --with-tests=""
RUN make -j && make install
RUN make distclean

#ARM32
RUN ./configure --prefix=$INSTALLATION_PREFIX/arm32/papi --host=arm-linux-gnueabihf --target=arm-linux-gnueabihf   --with-arch=arm \
    --with-CPU=arm --with-ffsll --with-walltimer=cycle -with-tls=__thread \
    --with-virtualtimer=perfctr --with-perf-events --with-tests=""
RUN make -j && make install
RUN make distclean


#X86_64
RUN ./configure --prefix=$INSTALLATION_PREFIX/x86_64/papi --host=x86_64-linux-gnu --target=x86_64-linux-gnu  --with-perf-events \
    --with-CPU=core --with-ffsll --with-walltimer=cycle -with-tls=__thread \
    --with-virtualtimer=perfctr --with-perf-events --with-tests=""
RUN make -j && make install
RUN make distclean


#BINUTILS


WORKDIR /tmp/work/

RUN wget https://ftp.gnu.org/gnu/binutils/binutils-2.37.tar.gz \
 && tar -zxf binutils-2.37.tar.gz \
 && rm binutils-2.37.tar.gz
WORKDIR /tmp/work/binutils-2.37

#ARM64
RUN ./configure --prefix=$INSTALLATION_PREFIX/arm64/binutils --host=aarch64-linux-gnu --enable-shared \
    --enable-install-libiberty \
 && make tooldir=$INSTALLATION_PREFIX/arm64/binutils && make tooldir=$INSTALLATION_PREFIX/arm64/binutils install && make distclean

#ARM32
RUN ./configure --prefix=$INSTALLATION_PREFIX/arm32/binutils --host=arm-linux-gnueabihf --enable-shared \
    --enable-install-libiberty \
 && make tooldir=$INSTALLATION_PREFIX/arm32/binutils && make tooldir=$INSTALLATION_PREFIX/arm32/binutils install && make distclean

#X86_64
RUN ./configure --prefix=$INSTALLATION_PREFIX/x86_64/binutils --host=x86_64-linux-gnu --enable-shared \
    --enable-install-libiberty \
 && make tooldir=$INSTALLATION_PREFIX/x86_64/binutils && make tooldir=$INSTALLATION_PREFIX/x86_64/binutils install && make distclean


#ZLIB
WORKDIR /tmp/work/

RUN  wget https://zlib.net/zlib-1.2.13.tar.gz  && tar -zxf zlib-1.2.13.tar.gz  && rm zlib-1.2.13.tar.gz

WORKDIR /tmp/work/zlib-1.2.13

#ARM64
RUN CHOST=aarch64-linux-gnu ./configure --prefix=$INSTALLATION_PREFIX/arm64/libz  && CHOST=aarch64-linux-gnu make install  && make distclean

#ARM32
RUN CHOST=arm-linux-gnueabihf ./configure --prefix=$INSTALLATION_PREFIX/arm32/libz  && CHOST=arm-linux-gnueabihf make install && make distclean

#X86_64
RUN CHOST=x86_64-linux-gnu  ./configure --prefix=$INSTALLATION_PREFIX/x86_64/libz  && CHOST=x86_64-linux-gnu make install && make distclean


#LIBXML2
WORKDIR /tmp/work/
RUN wget https://gitlab.gnome.org/GNOME/libxml2/-/archive/v2.9.12/libxml2-v2.9.12.tar.gz \
 && tar -zxf libxml2-v2.9.12.tar.gz \
 && rm libxml2-v2.9.12.tar.gz

WORKDIR /tmp/work/libxml2-v2.9.12

RUN autoreconf -ifv

#ARM64
RUN ./configure --prefix=$INSTALLATION_PREFIX/arm64/libxml2 --host=aarch64-linux-gnu  --with-zlib=$INSTALLATION_PREFIX/arm64/libz --without-python \
 && make install && make distclean

#ARM32
RUN ./configure --prefix=$INSTALLATION_PREFIX/arm32/libxml2 --host=arm-linux-gnueabihf  --with-zlib=$INSTALLATION_PREFIX/arm32/libz --without-python \
 && make install && make distclean

#X86_64
RUN ./configure --prefix=$INSTALLATION_PREFIX/x86_64/libxml2 --host=x86_64-linux-gnu --with-zlib=$INSTALLATION_PREFIX/x86_64/libz --without-python \
    && make install && make distclean

#ONLY COMPILE PARAVER FOR LOCAL MACHINE

WORKDIR /tmp/work/

RUN git clone https://github.com/bsc-performance-tools/paraver-kernel
WORKDIR /tmp/work/paraver-kernel
RUN ./bootstrap

RUN ./configure --with-boost-libdir=/usr/lib/$(gcc -dumpmachine)  --prefix=$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/paraver
RUN make && make install


WORKDIR /tmp/work
RUN apt install -y libwxgtk3.0-gtk3-dev libssl-dev
RUN git clone  https://github.com/bsc-performance-tools/wxparaver

WORKDIR /tmp/work/wxparaver
RUN ./bootstrap
RUN ./configure --with-boost-libdir=/usr/lib/$(gcc -dumpmachine)  --prefix=$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/paraver
RUN make && make install


WORKDIR /tmp/work/

ADD Makefile ./
ADD ait ./ait
ADD extrae ./extrae
ADD mcxx ./mcxx
ADD nanox ./nanox
ADD ompss-at-fpga-kernel-module ./ompss-at-fpga-kernel-module
ADD xdma ./xdma
ADD xtasks ./xtasks


#EXTRAE

WORKDIR /tmp/work/extrae


ENV CFLAGS=-lpthread
ENV CXXFLAGS=-lpthread
ENV LDFLAGS=-lpthread
RUN ./bootstrap

#ARM64
RUN ./configure --prefix=$INSTALLATION_PREFIX/arm64/ompss/${RELEASE_TAG}/extrae --host=aarch64-linux-gnu --enable-arm64 \
    --without-mpi --without-unwind --without-dyninst --with-papi=$INSTALLATION_PREFIX/arm64/papi \
    --with-libz=$INSTALLATION_PREFIX/arm64/libz --with-binutils=$INSTALLATION_PREFIX/arm64/binutils \
    --with-xml-prefix=$INSTALLATION_PREFIX/arm64/libxml2
RUN make -j && make install && make distclean

#ARM32
RUN ./configure --prefix=$INSTALLATION_PREFIX/arm32/ompss/${RELEASE_TAG}/extrae --host=arm-linux-gnueabihf --enable-arm \
    --without-mpi --without-unwind --without-dyninst --with-papi=$INSTALLATION_PREFIX/arm32/papi \
    --with-libz=$INSTALLATION_PREFIX/arm32/libz --with-binutils=$INSTALLATION_PREFIX/arm32/binutils \
    --with-xml-prefix=$INSTALLATION_PREFIX/arm32/libxml2
RUN make -j && make install && make distclean

#X86_64
RUN ./configure --prefix=$INSTALLATION_PREFIX/x86_64/ompss/${RELEASE_TAG}/extrae --host=x86_64-linux-gnu --enable-amd64 \
    --without-mpi --without-unwind --without-dyninst --with-papi=$INSTALLATION_PREFIX/x86_64/papi \
    --with-libz=$INSTALLATION_PREFIX/x86_64/libz --with-binutils=$INSTALLATION_PREFIX/x86_64/binutils \
    --with-xml-prefix=$INSTALLATION_PREFIX/x86_64/libxml2
RUN make -j && make install && make distclean

ENV CFLAGS=
ENV CXXFLAGS=
ENV LDFLAGS=

#INSTALL TOOLCHAIN
WORKDIR /tmp/work

#X86_64
RUN make -j PREFIX_TARGET=$INSTALLATION_PREFIX/x86_64/ompss/${RELEASE_TAG} PREFIX_HOST=$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG} TARGET=$(test $(arch) != x86_64 && echo x86_64-linux-gnu) PLATFORM=qdma \
    EXTRAE_HOME=$INSTALLATION_PREFIX/x86_64/ompss/${RELEASE_TAG}/extrae MCXX_NAME=mcxx-x86_64 \
    all
RUN  make mrproper

#ARM64
RUN make -j PREFIX_TARGET=$INSTALLATION_PREFIX/arm64/ompss/${RELEASE_TAG} PREFIX_HOST=$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG} TARGET=$(test $(arch) != aarch64 && echo aarch64-linux-gnu) \
    EXTRAE_HOME=$INSTALLATION_PREFIX/arm64/ompss/${RELEASE_TAG}/extrae MCXX_NAME=mcxx-arm64 \
    all
RUN make mrproper

#ARM32
#Assuming no one will compile from an arm32 platform => always setting TARGET
RUN make -j PREFIX_TARGET=$INSTALLATION_PREFIX/arm32/ompss/${RELEASE_TAG} PREFIX_HOST=$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG} TARGET=arm-linux-gnueabihf \
    EXTRAE_HOME=$INSTALLATION_PREFIX/arm32/ompss/${RELEASE_TAG}/extrae MCXX_NAME=mcxx-arm32 \
    all
RUN  make mrproper


FROM installed_pkg AS dist_img
ARG INSTALLATION_PREFIX
ARG RELEASE_TAG

ARG INSTALLATION_PREFIX
COPY --from=build $INSTALLATION_PREFIX $INSTALLATION_PREFIX
LABEL AUTHOR="Programming Models Group at BSC <ompss-fpga-support@bsc.es> (https://pm.bsc.es/ompss-at-fpga)"

ARG BUILD_ONLY
RUN if [ "$BUILD_ONLY" = "true" ]; \
    then true; \
    else apt update &&  apt install -y  sudo libwxgtk3.0-gtk3-dev build-essential libsqlite3-dev crossbuild-essential-armhf && rm -rf /var/lib/apt/lists/* && apt clean; \
        if [ \"`arch`\" = \"aarch64\" ] || [ \"`arch`\" = \"arm64\" ]; then  \
            apt install crossbuild-essential-amd64; \
        fi; \
    fi


RUN  adduser --disabled-password --gecos '' ompss \
 && adduser ompss sudo \
 && echo 'ompss:ompss' | chpasswd \
 && echo "export PATH=\$PATH:$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG}/mcxx-arm64/bin" >>$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG}/environment_ompss_fpga.sh \
 && echo "export PATH=\$PATH:$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG}/mcxx-arm32/bin" >>$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG}/environment_ompss_fpga.sh \
 && echo "export PATH=\$PATH:$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG}/mcxx-x86_64/bin" >>$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG}/environment_ompss_fpga.sh \
 && echo "export PATH=\$PATH:$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG}/ait/bin" >>$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG}/environment_ompss_fpga.sh \
 && echo "export PYTHONPATH=$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG}/ait" >>$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG}/environment_ompss_fpga.sh
ADD ./dockerImageFiles/welcome_ompss_fpga.txt $INSTALLATION_PREFIX
WORKDIR /home/ompss/
USER ompss
ADD --chown=ompss:ompss ./dockerImageFiles/example ./example/
#RUN ln -s $INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG}/nanox/share/doc/nanox/paraver_configs/ompss ./example/paraver_configs \
RUN echo "export PATH=\$PATH:$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/wxparaver/bin" >>.bashrc \
 && echo "cat $INSTALLATION_PREFIX/welcome_ompss_fpga.txt" >>.bashrc \
 && echo "export PATH=\$PATH:$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG}/mcxx-arm64/bin" >>.bashrc \
 && echo "export PATH=\$PATH:$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG}/mcxx-arm32/bin" >>.bashrc \
 && echo "export PATH=\$PATH:$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG}/mcxx-x86_64/bin" >>.bashrc  \
 && echo "export PATH=\$PATH:$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG}/ait/bin" >>.bashrc \
 && echo "export PYTHONPATH=$INSTALLATION_PREFIX/$(arch | sed 's/aarch64/arm64/g' | sed 's/armhf/arm32/g')/ompss/${RELEASE_TAG}/ait" >>.bashrc

CMD ["bash"]
