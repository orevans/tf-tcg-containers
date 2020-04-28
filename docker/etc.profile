# /etc/profile: system-wide .profile file for the Bourne shell (sh(1))
# and Bourne compatible shells (bash(1), ksh(1), ash(1), ...).

if [ "${PS1-}" ]; then
  if [ "${BASH-}" ] && [ "$BASH" != "/bin/sh" ]; then
    # The file bash.bashrc already sets the default PS1.
    # PS1='\h:\w\$ '
    if [ -f /etc/bash.bashrc ]; then
      . /etc/bash.bashrc
    fi
  else
    if [ "`id -u`" -eq 0 ]; then
      PS1='# '
    else
      PS1='$ '
    fi
  fi
fi

if [ -d /etc/profile.d ]; then
  for i in /etc/profile.d/*.sh; do
    if [ -r $i ]; then
      . $i
    fi
  done
  unset i
fi

# enable environment modules.                                                                                                                                          
if [ -f /usr/share/modules/init/bash ]; then
    .  /usr/share/modules/init/bash
    export MODULEPATH=/usr/local/share/environment-modules:${MODULEPATH}
fi


if [ "x$MODULESHOME" != "x" ]; then
  if [ `module avail -t 2>&1 | grep -c '^openmpi'` -gt 0 ]; then module load openmpi; fi
  if [ `module avail -t 2>&1 | grep -c '^hdf5'` -gt 0 ]; then module load hdf5; fi
  if [ `module avail -t 2>&1 | grep -c '^pybind11'` -gt 0 ]; then module load pybind11; fi
  if [ `module avail -t 2>&1 | grep -c '^petsc'` -gt 0 ]; then module load petsc; fi
  if [ `module avail -t 2>&1 | grep -c '^fenics'` -gt 0 ]; then module load fenics; fi
  if [ `module avail -t 2>&1 | grep -c '^spud'` -gt 0 ]; then module load spud; fi
  if [ `module avail -t 2>&1 | grep -c '^terraferma'` -gt 0 ]; then module load terraferma; fi
  if [ `module avail -t 2>&1 | grep -c '^tferma_utils'` -gt 0 ]; then module load tferma_utils; fi
  if [ `module avail -t 2>&1 | grep -c '^extra_scripts'` -gt 0 ]; then module load extra_scripts; fi
  if [ `module avail -t 2>&1 | grep -c '^gmsh'` -gt 0 ]; then module load gmsh; fi
  if [ `module avail -t 2>&1 | grep -c '^thermocodegen'` -gt 0 ]; then module load thermocodegen; fi
fi


