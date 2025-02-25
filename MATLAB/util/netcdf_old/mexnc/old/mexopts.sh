#
# mexopts.sh	Shell script for configuring MEX-file creation script,
#               mex.  These options were tested with the specified compiler.
#
# usage:        Do not call this file directly; it is sourced by the
#               mex shell script.  Modify only if you don't like the
#               defaults after running mex.  No spaces are allowed
#               around the '=' in the variable assignment.
#
# Note: For the version of system compiler supported with this release,
#       refer to Technical Note 1601 at:
#       http://www.mathworks.com/support/tech-notes/1600/1601.html
#
#
# SELECTION_TAGs occur in template option files and are used by MATLAB
# tools, such as mex and mbuild, to determine the purpose of the contents
# of an option file. These tags are only interpreted when preceded by '#'
# and followed by ':'.
#
#SELECTION_TAG_MEX_OPT: Template Options file for building MEX-files via the system ANSI compiler
#
# Copyright 1984-2004 The MathWorks, Inc.
# $Revision: 1.78.4.9.28.1 $  $Date: 2006/02/02 01:45:38 $
#----------------------------------------------------------------------------
#
    TMW_ROOT="$MATLAB"
    MFLAGS=''
    if [ "$ENTRYPOINT" = "mexLibrary" ]; then
        MLIBS="-L$TMW_ROOT/bin/$Arch -lmx -lmex -lmat -lmwservices -lut"
    else  
        MLIBS="-L$TMW_ROOT/bin/$Arch -lmx -lmex -lmat"
    fi
    case "$Arch" in
        Undetermined)
#----------------------------------------------------------------------------
# Change this line if you need to specify the location of the MATLAB
# root directory.  The script needs to know where to find utility
# routines so that it can determine the architecture; therefore, this
# assignment needs to be done while the architecture is still
# undetermined.
#----------------------------------------------------------------------------
            MATLAB="$MATLAB"
            ;;
        glnx86)
#----------------------------------------------------------------------------
            RPATH="-Wl,-rpath-link,$TMW_ROOT/bin/$Arch"
            CC='gcc'
            CFLAGS='-fPIC -ansi -D_GNU_SOURCE -pthread -fexceptions -m32'
            CLIBS="$RPATH $MLIBS -lm -lstdc++"
            COPTIMFLAGS='-O -DNDEBUG'
            CDEBUGFLAGS='-g'
#           
            CXX='g++'
            CXXFLAGS='-fPIC -ansi -D_GNU_SOURCE -pthread '
            CXXLIBS="$RPATH $MLIBS -lm"
            CXXOPTIMFLAGS='-O -DNDEBUG'
            CXXDEBUGFLAGS='-g'
#
#           NOTE: g77 is not thread safe
            FC='g77'
            FFLAGS='-fPIC -fexceptions'
            FLIBS="$RPATH $MLIBS -lm -lstdc++"
            FOPTIMFLAGS='-O'
            FDEBUGFLAGS='-g'
#
            LD="$COMPILER"
            LDEXTENSION='.mexglx'
            LDFLAGS="-pthread -shared -m32 -Wl,--version-script,$TMW_ROOT/extern/lib/$Arch/$MAPFILE"
            LDOPTIMFLAGS='-O'
            LDDEBUGFLAGS='-g'
#
            POSTLINK_CMDS=':'
#----------------------------------------------------------------------------
            ;;
        glnxa64)
#----------------------------------------------------------------------------
            RPATH="-Wl,-rpath-link,$TMW_ROOT/bin/$Arch"
            CC='gcc'
            CFLAGS='-fPIC -fno-omit-frame-pointer -ansi -D_GNU_SOURCE -pthread -fexceptions'
            CLIBS="$RPATH $MLIBS -lm -lstdc++"
            COPTIMFLAGS='-O -DNDEBUG'
            CDEBUGFLAGS='-g'
#           
            CXX='g++'
            CXXFLAGS='-fPIC -fno-omit-frame-pointer -ansi -D_GNU_SOURCE -pthread '
            CXXLIBS="$RPATH $MLIBS -lm"
            CXXOPTIMFLAGS='-O -DNDEBUG'
            CXXDEBUGFLAGS='-g'
#
#           NOTE: g77 is not thread safe
            FC='g77'
            FFLAGS='-fPIC -fno-omit-frame-pointer -fexceptions'
            FLIBS="$RPATH $MLIBS -lm -lstdc++"
            FOPTIMFLAGS='-O'
            FDEBUGFLAGS='-g'
#
            LD="$COMPILER"
            LDEXTENSION='.mexa64'
            LDFLAGS="-pthread -shared -Wl,--version-script,$TMW_ROOT/extern/lib/$Arch/$MAPFILE"
            LDOPTIMFLAGS='-O'
            LDDEBUGFLAGS='-g'
#
            POSTLINK_CMDS=':'
#----------------------------------------------------------------------------
            ;;
        sol2)
#----------------------------------------------------------------------------
            CC='cc'
            CFLAGS='-KPIC -dalign -xlibmieee -D__EXTENSIONS__ -D_POSIX_C_SOURCE=199506L -mt'
            CFLAGS="$CFLAGS -D_XOPEN_SOURCE=600"
            CLIBS="$MLIBS -lm -lc"
            COPTIMFLAGS='-xO3 -xlibmil -DNDEBUG'
            CDEBUGFLAGS='-xs -g'
#           
            CXX='CC -compat=5'
            CCV=`CC -V 2>&1`
            version=`expr "$CCV" : '.*\([0-9][0-9]*\)\.'`
            if [ "$version" = "4" ]; then
                    echo "SC5.0 or later C++ compiler is required"
            fi
            CXXFLAGS='-KPIC -dalign -xlibmieee -D__EXTENSIONS__ -D_POSIX_C_SOURCE=199506L -mt'
            CXXLIBS="$MLIBS -lm -lCstd -lCrun"
            CXXOPTIMFLAGS='-xO3 -xlibmil -DNDEBUG'
            CXXDEBUGFLAGS='-xs -g'
#
            FC='f90'
            FFLAGS='-KPIC -dalign -mt'
            FLIBS="$MLIBS -lfui -lfsu -lsunmath -lm -lc"
            FOPTIMFLAGS='-O'
            FDEBUGFLAGS='-xs -g'
#
            LD="$COMPILER"
            LDEXTENSION='.mexsol'
            LDFLAGS="-G -mt -M$TMW_ROOT/extern/lib/$Arch/$MAPFILE"
            LDOPTIMFLAGS='-O'
            LDDEBUGFLAGS='-xs -g'
#
            POSTLINK_CMDS=':'
#----------------------------------------------------------------------------
            ;;
        mac)
#----------------------------------------------------------------------------
            CC='gcc-3.3'
            CFLAGS='-fno-common -no-cpp-precomp -fexceptions'
            CLIBS="$MLIBS -lstdc++"
            COPTIMFLAGS='-O3 -DNDEBUG'
            CDEBUGFLAGS='-g'
#
            CXX=g++-3.3
            CXXFLAGS='-fno-common -no-cpp-precomp -fexceptions'
            CXXLIBS="$MLIBS -lstdc++"
            CXXOPTIMFLAGS='-O3 -DNDEBUG'
            CXXDEBUGFLAGS='-g'
#
            FC='f77'
            FFLAGS='-f -N15 -N11 -s -Q51 -W'
            ABSOFTLIBDIR=`which $FC | sed -n -e '1s|bin/'$FC'|lib|p'`
            FLIBS="-L$ABSOFTLIBDIR -lfio -lf77math"
            FOPTIMFLAGS='-O -cpu:g4'
            FDEBUGFLAGS='-g'
#
            LD="$CC"
            LDEXTENSION='.mexmac'
            LDFLAGS="-bundle -Wl,-flat_namespace -undefined suppress -Wl,-exported_symbols_list,$TMW_ROOT/extern/lib/$Arch/$MAPFILE"
            LDOPTIMFLAGS='-O'
            LDDEBUGFLAGS='-g'
#
            POSTLINK_CMDS=':'
#----------------------------------------------------------------------------
            ;;
    esac
#############################################################################
#
# Architecture independent lines:
#
#     Set and uncomment any lines which will apply to all architectures.
#
#----------------------------------------------------------------------------
#           CC="$CC"
#           CC="/mathworks/hub/Linux/glibc-2.3.4/x86_64/apps/gcc-3.4.5/bin/gcc"  # x86_64
#    CC="/mathworks/hub/Linux/glibc-2.3.2/i686/apps/gcc-3.4.5/bin/gcc" # linux x86
    NETCDF="/local/netcdf-3.6.2"
    NETCDF="/home/johne/local/sol2"
    NETCDF="/home/johne/local/glnx86"
    NETCDF="/home/johne/local/mac"
    EXTRA_CFLAGS="-I${NETCDF}/include -Wall"          # gcc only
    EXTRA_CFLAGS="-I${NETCDF}/include"
    EXTRA_CLIBS="-L${NETCDF}/lib -lnetcdf "
    CFLAGS="-g $CFLAGS ${EXTRA_CFLAGS}"
    CLIBS="$CLIBS ${EXTRA_CLIBS} "
#           CFLAGS="$CFLAGS"
#           COPTIMFLAGS="$COPTIMFLAGS"
#           CDEBUGFLAGS="$CDEBUGFLAGS"
#           CLIBS="$CLIBS"
#
#           FC="$FC"
#           FFLAGS="$FFLAGS"
#           FOPTIMFLAGS="$FOPTIMFLAGS"
#           FDEBUGFLAGS="$FDEBUGFLAGS"
#           FLIBS="$FLIBS"
#
#           LD="$LD"
#           LDFLAGS="$LDFLAGS"
#           LDOPTIMFLAGS="$LDOPTIMFLAGS"
#           LDDEBUGFLAGS="$LDDEBUGFLAGS"
#----------------------------------------------------------------------------
#############################################################################
