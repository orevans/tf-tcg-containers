# System-wide .bashrc file for interactive bash(1) shells.

# To enable the settings / commands in this file for login shells as well,
# this file has to be sourced in /etc/profile.

# enable environment modules.                                                                                                                                          
if [ -f /usr/share/modules/init/bash ]; then
    .  /usr/share/modules/init/bash
    export MODULEPATH=/usr/local/share/environment-modules:${MODULEPATH}
fi


if [ "x$MODULESHOME" != "x" ]; then
  #if [ `module avail -t 2>&1 | grep -c '^openmpi'` -gt 0 ]; then module load openmpi; fi
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

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, overwrite the one in /etc/profile)
# but only if not SUDOing and have SUDO_PS1 set; then assume smart user.
if ! [ -n "${SUDO_USER}" -a -n "${SUDO_PS1}" ]; then
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

# Commented out, don't overwrite xterm -T "title" -n "icontitle" by default.
# If this is an xterm set the title to user@host:dir
#case "$TERM" in
#xterm*|rxvt*)
#    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
#    ;;
#*)
#    ;;
#esac

# enable bash completion in interactive shells
#if ! shopt -oq posix; then
#  if [ -f /usr/share/bash-completion/bash_completion ]; then
#    . /usr/share/bash-completion/bash_completion
#  elif [ -f /etc/bash_completion ]; then
#    . /etc/bash_completion
#  fi
#fi

# sudo hint
if [ ! -e "$HOME/.sudo_as_admin_successful" ] && [ ! -e "$HOME/.hushlogin" ] ; then
    case " $(groups) " in *\ admin\ *|*\ sudo\ *)
    if [ -x /usr/bin/sudo ]; then
	cat <<-EOF
	To run a command as administrator (user "root"), use "sudo <command>".
	See "man sudo_root" for details.
	
	EOF
    fi
    esac
fi

# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found -o -x /usr/share/command-not-found/command-not-found ]; then
	function command_not_found_handle {
	        # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
		   /usr/lib/command-not-found -- "$1"
                   return $?
                elif [ -x /usr/share/command-not-found/command-not-found ]; then
		   /usr/share/command-not-found/command-not-found -- "$1"
                   return $?
		else
		   printf "%s: command not found\n" "$1" >&2
		   return 127
		fi
	}
fi
