# Copyright (C) 2018 ENKI Project
#
# Please see the AUTHORS file in the main source directory for a full list
# of contributors.
#
# This file is part of Thermocodegen
#
# Thermocodegen is free software: you can redistribute it and/or modify
# it under the terms of the MIT License
#
# Thermocodegen is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# License for more details.
#
# You should have received a copy of the MIT
# along with Thermocodegen
#
# Builds a Docker image with a full installation of TerraFERMA v2.0 and ThermoCodegen v0.6.1
# The built image can be found at#
#   https://hub.docker.com/repository/docker/orevans/terraferma-thermocodegen
#

# build using the TerraFERMA v2.0
FROM terraferma/dev:fenics-2019.1.0
MAINTAINER oevans <ore2000@columbia.edu>

USER root
WORKDIR /tmp

# download and install gmsh from source
ENV GMSH_PREFIX /usr/local/gmsh
RUN git clone -b gmsh_4_0_7 -q https://gitlab.onelab.info/gmsh/gmsh.git && \
cd gmsh && \
mkdir build && \
cd build && \
cmake -DCMAKE_INSTALL_PREFIX=${GMSH_PREFIX} ../. && \
make && \
make install && \
pip3 install pygmsh && \
pip3 install meshio && \
rm -rf /tmp/*
# install an environment module for gmsh
COPY gmsh.configmodule /usr/local/share/environment-modules/gmsh

# install thermocodegen dependencies
RUN pip3 install \
                 -Iv sympy==1.3 \
                 pandas \
                 requests \
                 pytest \
                 cython \
                 jupyterlab
                 
# install a few extra packages
RUN apt-get update && \
    apt-get -y --with-new-pkgs \
        -o Dpkg::Options::="--force-confold" -o Dpkg::Options::="--force-confdef" upgrade && \
    apt-get -y install \
                       eog \
                       libgsl-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# copy local version of ThermoCodegen and install thermocodegen using cmake
ENV THERMOCODEGEN_HOME /usr/local/thermocodegen
COPY ./ThermoCodegen .
ENV SPUD_DIR /usr/local/spud
RUN mkdir build && \
cd build && \
cmake ..  -DCMAKE_INSTALL_PREFIX=${THERMOCODEGEN_HOME} \
          -DVERSION_MAJOR=0 -DVERSION_MINOR=6 -DVERSION_PATCH=1 && \
make install && \
rm -rf /tmp/*

# Create symbolic link for /usr/bin/python 
RUN ln -s /usr/bin/python3 /usr/bin/python

# install an environment module for thermoCodegen
COPY thermocodegen.configmodule /usr/local/share/environment-modules/thermocodegen

# download paraview
#RUN wget "https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.7&type=binary&os=Linux&downloadFile=ParaView-5.7.0-MPI-Linux-Python3.7-64bit.tar.gz" -O paraview.tar.gz && \
#    tar -xzf paraview.tar.gz && \
#    rm paraview.tar.gz

# download and install tferma_utils from source
ENV TFERMA_UTILS_PREFIX /usr/local/tferma_utils
ARG CACHEBUST=1
RUN git clone -b fenics-2019.1.0 -q https://bitbucket.org/tferma/tferma_utils.git && \
    cd tferma_utils && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX=${TFERMA_UTILS_PREFIX} ../. && \
    make && \
    make install && \
    rm -rf /tmp/*
# install an environment module for tferma_utils
COPY tferma_utils.configmodule /usr/local/share/environment-modules/tferma_utils

# setup system profile to initialize and load  modules for interactive shells
COPY etc.profile /etc/profile

USER tfuser
WORKDIR $TF_HOME

COPY bash.load-modules $TF_HOME/.bash.load-modules
COPY tfuser.profile $TF_HOME/.profile
# set some useful aliases
COPY bash_aliases $TF_HOME/.bash_aliases
# update welcome message
COPY WELCOME $TF_HOME/WELCOME

USER root
