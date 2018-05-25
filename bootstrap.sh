#! /usr/bin/env bash
#########################################################################
#									#
#	bootstrap.sh is automatically generated,			#
#		please do not modify!					#
#									#
#########################################################################

#########################################################################
#									#
# Script ID: bootstrap.sh						#
# Author: Copyright (C) 2014-2018  Mark Grant				#
#									#
# Released under the GPLv3 only.					#
# SPDX-License-Identifier: GPL-3.0					#
#									#
# Purpose:								#
# To simplify the AutoTools distribution build.				#
#									#
# Syntax:	bootstrap.sh	[ -c || --distcheck ] ||		#
#				[ -d || --debug ] ||			#
#				[ -D || --dist ] ||			#
#				[ -f || --distcheckfake ] ||		#
#				[ -g || --gnulib ] ||			#
#				[ -h || --help ] ||			#
#				[ -m || --make ] ||			#
#				[ -s || --sparse ] ||			#
#				[ -t || --source-tarball ] ||		#
#				[ -V || --version-V ]			#
#									#
# Exit Codes:	0 - success						#
#		1 - failure.						#
#									#
# Further Info:								#
#									#
#########################################################################

#########################################################################
#									#
# Changelog								#
#									#
# Date		Author	Version	Description				#
#									#
# 25/06/2014	MG	1.0.1	Created.				#
# 02/08/2014	MG	1.0.2	Change naming from AutoTools to		#
#				AutoConf and Make.			#
# 27/10/2014	MG	1.0.3	Seperated each command in order to test	#
#				exit status.				#
# 13/11/2014	MG	1.0.4	Switched from getopts to GNU getopt to	#
#				allow long options.			#
# 16/11/2014	MG	1.0.5	Modify getopt processing to allow for	#
#				FreeBSD's quirk of 2 different getopt	#
#				programs. See comments at the start of	#
#				"Main"					#
# 16/11/2014	MG	1.0.6	Remove erroneous option.		#
# 18/11/2014	MG	1.0.7	Change FreeBSD specifics to *BSD and	#
#				change Linux to be the default.		#
# 24/11/2014	MG	1.0.8	Add overall package version to -V.	#
# 28/03/2015	MG	1.0.9	Remove BSD support.			#
# 31/01/2017	MG	1.1.1	Add debug make dist and make options.	#
# 25/02/2017	MG	1.2.0	Add distcheck & distcheckfake options.	#
# 25/06/2017	MG	1.2.1	Enforce 80 column rule.			#
# 01/12/2017	MG	1.2.2	Add SPDX license tags to source files.	#
# 04/12/2017	MG	1.2.3	Adopt standard exit codes; 0 on success	#
#				1 on failure.				#
# 06/02/2018	MG	1.3.1	Renamed from acmbuild.			#
#				Add -g option.				#
#				General script tidy up.			#
# 09/02/2018	MG	1.3.2	Remove script name from -V --version	#
#				print as this may have been invoked by	#
#				acmbuild.sh.				#
# 24/03/2018	MG	1.3.3	Add support for sparse CLA.		#
#				Add stderr log file.			#
# 07/04/2018	MG	1.3.4	Add -t --source-tarball CLA to build a	#
#				source tarball.				#
#									#
#########################################################################

##################
# Init variables #
##################
script_exit_code=0
version="1.3.4"			# set version variable
packageversion=v1.2.7	# Version of the complete package

debug=""
dist=FALSE
distcheck=FALSE
distcheckfake=FALSE
gnulib=FALSE
make=FALSE
sparse=""
tarball=FALSE
basedir="."
cmdline=""


#############
# Functions #
#############

# Output $1 to stdout or stderr depending on $2.
output()
{
	if [ $2 = 0 ]
	then
		echo "$1"
	else
		echo "$1" 1>&2
	fi
}

# Standard function to test command error ($1 is $?) and exit if non-zero
std_cmd_err_handler()
{
	if [ $1 != 0 ]
	then
		script_exit_code=$1
		script_exit
	fi
}

# Standard function to cleanup and return exit code
script_exit()
{
	exit $script_exit_code
}

# Standard trap exit function
trap_exit()
{
script_exit_code=1
output "Script terminating due to trap received." 1
script_exit
}

# Setup trap
trap trap_exit SIGHUP SIGINT SIGTERM

########
# Main #
########
# Process command line arguments with GNU getopt.
tmp="getopt -o cdDfghmstV "
tmp+="--long distcheck,debug,dist,distcheckfake,gnulib,help,make,sparse,"
tmp+="source-tarball,version "
tmp+="-n $0 -- $@"
GETOPTTEMP=`eval $tmp`
eval set -- "$GETOPTTEMP"
std_cmd_err_handler $?


while true
do
	case "$1" in
	-c|--distcheck)
		if [ $dist = TRUE -o $distcheckfake = TRUE -o $make = TRUE \
			-o $tarball = TRUE ]
		then
			script_exit_code=1
			msg="Options c, D, f, m and t are mutually exclusive."
			output "$msg" 1
			script_exit
		fi
		distcheck=TRUE
		shift
		;;
	-d|--debug)
		debug=" --enable-debug=yes"
		shift
		;;
	-D|--dist)
		if [ $distcheck = TRUE -o $distcheckfake = TRUE \
			-o $make = TRUE -o $tarball = TRUE ]
		then
			script_exit_code=1
			msg="Options c, D, f, m and t are mutually exclusive."
			output "$msg" 1
			script_exit
		fi
		dist=TRUE
		shift
		;;
	-f|--distcheckfake)
		if [ $distcheck = TRUE -o $dist = TRUE -o $make = TRUE \
			-o $tarball = TRUE ]
		then
			script_exit_code=1
			msg="Options c, D, f, m and t are mutually exclusive."
			output "$msg" 1
			script_exit
		fi
		distcheckfake=TRUE
		shift
		;;
	-g|--gnulib)
		gnulib=TRUE
		shift
		;;
	-h|--help)
		echo "Usage is:-"
		echo "	-c or --distcheck perform normal distcheck"
		echo "	-d or --debug build with appropriate debug flags"
		echo "	-D or --dist perform a make dist"
		echo "	-f or --distcheckfake fake a distcheck for fixed root"
		echo "	-g or --gnulib run gnulib-tool --update"
		echo "	-h or --help displays usage information"
		echo "	-m or --make compile and link - plain make"
		echo "	-s or --sparse build using sparse"
		echo "	-t or --source-tarball create source tarball"
		echo "	-V or --version displays version information"
		shift
		script_exit_code=0
		script_exit
		;;
	-m|--make)
		if [ $distcheck = TRUE -o $dist = TRUE \
			-o $distcheckfake = TRUE -o $tarball = TRUE ]
		then
			script_exit_code=1
			msg="Options c, D, f, m and t are mutually exclusive."
			output "$msg" 1
			script_exit
		fi
		make=TRUE
		shift
		;;
	-s|--sparse)
		sparse=" --enable-sparse=yes"
		shift
		;;
	-t|--source-tarball)
		if [ $distcheck = TRUE -o $dist = TRUE \
			-o $distcheckfake = TRUE -o $make = TRUE ]
		then
			script_exit_code=1
			msg="Options c, D, f, m and t are mutually exclusive."
			output "$msg" 1
			script_exit
		fi
		tarball=TRUE
		shift
		;;
	-V|--version)
		echo "Script version "$version
		echo "Package version "$packageversion
		shift
		script_exit_code=0
		script_exit
		;;
	--)	shift
		break
		;;
	*)	script_exit_code=1
		output "Internal error." 1
		script_exit
		;;
	esac
done

# Script can accept 1 other argument, the base directory.
if [ $# -gt 1 ]
then
	script_exit_code=1
	output "Invalid argument." 1
	script_exit
fi

if [ $# -eq 1 ]
then
	basedir=$1
fi

# One option has to be selected.
if [ $distcheck = FALSE -a $dist = FALSE -a $distcheckfake = FALSE \
	-a $make = FALSE -a $tarball = FALSE ]
then
	script_exit_code=1
	output "Either c, D, f, m or t must be set." 1
	script_exit
fi

# Create build error log.
exec 2> >(tee build-stderr.txt >&2)


# Now the main processing.
if [ $gnulib = TRUE ]
then
	if [ -f $basedir/m4/gnulib-cache.m4 ]
	then
		cmdline="gnulib-tool --update --quiet --quiet --dir="$basedir
		eval "$cmdline"
		status=$?
		output "$cmdline completed with exit status: $status" $status
		std_cmd_err_handler $status
	else
		msg="Option -g --gnulib ignored - "
		msg+="missing $basedir/m4/gnulib-cache.m4"
		output "$msg" 0
	fi
fi

autoreconf -if $basedir
status=$?
output "autoreconf -if "$basedir" completed with exit status: $status" $status
std_cmd_err_handler $status

cmdline=$basedir"/configure --enable-silent-rules=yes"$debug$sparse

if [ $distcheckfake = TRUE ]
then
	cmdline=$cmdline" --enable-distcheckfake=yes"
fi

eval "$cmdline"
status=$?
output "$cmdline completed with exit status: $status" $status
std_cmd_err_handler $status

cmdline="make --quiet"
if [ $distcheck = TRUE ]
then
	cmdline=$cmdline" distcheck distclean"
fi

if [ $dist = TRUE ]
then
	cmdline=$cmdline" dist clean distclean"
fi

if [ $distcheckfake = TRUE ]
then
	cmdline=$cmdline" distcheck distclean"
	cmdline=$cmdline" DISTCHECK_CONFIGURE_FLAGS=--enable-distcheckfake=yes"
fi

if [ $tarball = TRUE ]
then
	cmdline=$cmdline" srctarball distclean"
fi

eval "$cmdline"
status=$?
output "$cmdline completed with exit status: $status" $status
std_cmd_err_handler $status


script_exit_code=0
script_exit
