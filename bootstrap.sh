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
# Syntax:	bootstrap.sh	[ -b || --build ] ||			#
#				[ -c || --config ] ||			#
#				[ -C || --distcheck ] ||		#
#				[ -d || --debug ] ||			#
#				[ -D || --dist ] ||			#
#				[ -F || --distcheckfake ] ||		#
#				[ -g || --gnulib ] ||			#
#				[ -h || --help ] ||			#
#				[ -H || --header-check ] ||		#
#				[ -s || --sparse ] ||			#
#				[ -T || --source-tarball ] ||		#
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
# 01/07/2018	MG	1.3.5	Separate configure from build actions	#
#				and make options more standardised.	#
# 06/08/2018	MG	1.3.6	Add -H --header-check option.		#
#				Change error log file to build log.	#
#									#
#########################################################################

##################
# Init variables #
##################
script_exit_code=0
version="1.3.6"			# set version variable
packageversion=v1.2.10	# Version of the complete package

build=FALSE
config=FALSE
debug=""
dist=FALSE
distcheck=FALSE
distcheckfake=FALSE
gnulib=FALSE
headercheck=""
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
tmp="getopt -o bcCdDFghHsTV "
tmp+="--long build,config,distcheck,debug,dist,distcheckfake,gnulib,help,"
tmp+="header-check,sparse,source-tarball,version "
tmp+="-n $0 -- $@"
GETOPTTEMP=`eval $tmp`
eval set -- "$GETOPTTEMP"
std_cmd_err_handler $?


while true
do
	case "$1" in
	-b|--build)
		if [ $distcheck = TRUE -o $dist = TRUE \
			-o $distcheckfake = TRUE -o $tarball = TRUE ]
		then
			script_exit_code=1
			msg="Options b, C, D, F and T are mutually exclusive."
			output "$msg" 1
			script_exit
		fi
		build=TRUE
		shift
		;;
	-c|--config)
		config=TRUE
		shift
		;;
	-C|--distcheck)
		if [ $build = TRUE -o $dist = TRUE -o $distcheckfake = TRUE \
			-o $tarball = TRUE ]
		then
			script_exit_code=1
			msg="Options b, C, D, F and T are mutually exclusive."
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
		if [ $build = TRUE -o $distcheck = TRUE \
			-o $distcheckfake = TRUE -o $tarball = TRUE ]
		then
			script_exit_code=1
			msg="Options b, C, D, F and T are mutually exclusive."
			output "$msg" 1
			script_exit
		fi
		dist=TRUE
		shift
		;;
	-F|--distcheckfake)
		if [ $build = TRUE -o $distcheck = TRUE -o $dist = TRUE \
			-o $tarball = TRUE ]
		then
			script_exit_code=1
			msg="Options b, C, D, F and T are mutually exclusive."
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
		echo "	-b or --build make the project"
		echo "	-c or --config congigure the project"
		echo "	-C or --distcheck perform normal distcheck"
		echo "	-d or --debug build with appropriate debug flags"
		echo "	-D or --dist perform a make dist"
		echo "	-F or --distcheckfake fake a distcheck for fixed root"
		echo "	-g or --gnulib run gnulib-tool --update"
		echo "	-h or --help displays usage information"
		echo "	-H or --header-check show include stack depth"
		echo "	-s or --sparse build using sparse"
		echo "	-T or --source-tarball create source tarball"
		echo "	-V or --version displays version information"
		shift
		script_exit_code=0
		script_exit
		;;
	-H|--header-check)
		headercheck=" --enable-headercheck=yes"
		shift
		;;
	-s|--sparse)
		sparse=" --enable-sparse=yes"
		shift
		;;
	-T|--source-tarball)
		if [ $build = TRUE -o $distcheck = TRUE -o $dist = TRUE \
			-o $distcheckfake = TRUE ]
		then
			script_exit_code=1
			msg="Options b, C, D, F and T are mutually exclusive."
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

if [ "$debug" != "" -o $distcheckfake = TRUE -o "$headercheck" != "" \
	-o "$sparse" != "" ]
then
	if [ $config = FALSE ]
	then
		script_exit_code=1
		msg="Options d, F, H and s require option c."
		output "$msg" 1
		script_exit
	fi
fi

# One option has to be selected.
if [ $build =  FALSE -a $config = FALSE -a $distcheck = FALSE -a $dist = FALSE \
	-a $distcheckfake = FALSE -a $gnulib = FALSE -a $tarball = FALSE ]
then
	script_exit_code=1
	output "Either b, c, C, D, F, g or T must be set." 1
	script_exit
fi

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


# Create build log.
exec 1> >(tee build-output.txt) 2>&1


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

if [ $config = TRUE ]
then
	autoreconf -if $basedir
	status=$?
	msg="autoreconf -if "$basedir" completed with exit status: $status"
	output "$msg" $status
	std_cmd_err_handler $status

	cmdline=$basedir"/configure --enable-silent-rules=yes"$debug$headercheck
	cmdline+=$sparse

	if [ $distcheckfake = TRUE ]
	then
		cmdline=$cmdline" --enable-distcheckfake=yes"
	fi

	eval "$cmdline"
	status=$?
	output "$cmdline completed with exit status: $status" $status
	std_cmd_err_handler $status
fi

cmdline=""
if [ $build = TRUE ]
then
	cmdline="make --quiet"
fi

if [ $distcheck = TRUE ]
then
	cmdline="make --quiet distcheck clean"
fi

if [ $dist = TRUE ]
then
	cmdline="make --quiet dist clean"
fi

if [ $distcheckfake = TRUE ]
then
	cmdline="make --quiet distcheck clean"
	cmdline=$cmdline" DISTCHECK_CONFIGURE_FLAGS=--enable-distcheckfake=yes"
fi

if [ $tarball = TRUE ]
then
	cmdline="make --quiet srctarball clean"
fi

# May get here with cmdline empty if, for example, only the -g option was set.
if [ "$cmdline" != "" ]
then
	eval "$cmdline"
	status=$?
	output "$cmdline completed with exit status: $status" $status
	std_cmd_err_handler $status
fi


script_exit_code=0
script_exit
