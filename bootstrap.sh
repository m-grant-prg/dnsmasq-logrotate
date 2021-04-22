#! /bin/bash
#########################################################################
#									#
#	bootstrap.sh is automatically generated,			#
#		please do not modify!					#
#									#
#########################################################################

#########################################################################
#									#
# Script ID: bootstrap.sh						#
# Author: Copyright (C) 2014-2019, 2021  Mark Grant			#
#									#
# Released under the GPLv3 only.					#
# SPDX-License-Identifier: GPL-3.0					#
#									#
# Purpose:								#
# To simplify the AutoTools distribution build.				#
#									#
# Syntax:	bootstrap.sh	[ -a || --at-only ] ||			#
#				[ -b || --build ] ||			#
#				[ -c || --config ] ||			#
#				[ -C || --distcheck ] ||		#
#				[ -d || --debug ] ||			#
#				[ -D || --dist ] ||			#
#				[ -g || --gnulib ] ||			#
#				[ -h || --help ] ||			#
#				[ -H || --header-check ] ||		#
#				[ -K || --check ] ||			#
#				[ -m || --menu-config ] ||		#
#				[ -p || --parallel-jobs ] ||		#
#				[ -s || --sparse ] ||			#
#				[ -t || --testing-hacks ] ||		#
#				[ -T || --source-tarball ] ||		#
#				[ -v || --verbose ] ||			#
#				[ -V || --version ] ||			#
#				[ -- ]					#
#				[ non-option arguments ]		#
#									#
# Exit codes used:-							#
# Bash standard Exit Codes:	0 - success				#
#				1 - general failure			#
# User-defined exit code range is 64 - 113				#
#	C/C++ Semi-standard exit codes from sysexits.h range is 64 - 78	#
#		EX_USAGE	64	command line usage error	#
#		EX_DATAERR	65	data format error		#
#		EX_NOINPUT	66	cannot open input		#
#		EX_NOUSER	67	addressee unknown		#
#		EX_NOHOST	68	host name unknown		#
#		EX_UNAVAILABLE	69	service unavailable		#
#		EX_SOFTWARE	70	internal software error		#
#		EX_OSERR	71	system error (e.g., can't fork)	#
#		EX_OSFILE	72	critical OS file missing	#
#		EX_CANTCREAT	73	can't create (user) output file	#
#		EX_IOERR	74	input/output error		#
#		EX_TEMPFAIL	75	temp failure; user is invited	#
#					to retry			#
#		EX_PROTOCOL	76	remote error in protocol	#
#		EX_NOPERM	77	permission denied		#
#		EX_CONFIG	78	configuration error		#
#	User-defined (here) exit codes range 79 - 113:			#
#		None							#
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
# 22/08/2018	MG	1.3.7	Add verbose option.			#
# 24/03/2019	MG	1.4.1	Style if, for and while loops after C.	#
#				Use -proper- booleans.			#
#				Remove script_exit_code variable 	#
#				propogating the exit code as a function	#
#				argument instead.			#
#				Improve trap exit code handling.	#
#				Re-factor into functions.		#
#				Introduce more meaningful exit codes.	#
#				Tidy up local and global variables.	#
#				Add -a --at-only option.		#
#				Add -t --testing-hacks option.		#
#				Add support for non-option arguments	#
#				which are not option arguments being	#
#				passed straight through to the		#
#				configure command line apart from the	#
#				first which is the base directory. This	#
#				allows support for things like		#
#				--prefix=... etc.			#
#				Add missing error check after getopt.	#
#				Replace #! env bash with absolute path	#
#				via configure.				#
# 05/04/2019	MG	1.4.2	Just execute getopt command AOT eval.	#
#				Setup trap as early as possible.	#
# 30/04/2019	MG	1.4.3	Correct getopt CL for proper quoting.	#
#				Ensure variables used as input to other	#
#				commands are inputised and evaluated	#
#				with eval.				#
# 18/06/2019	MG	1.4.4	Add -K --check option to run		#
#				make --quiet check.			#
# 25/06/2019	MG	1.4.5	Remove distcheckfake option. Now done	#
#				by distcheck with configure flags in	#
#				top level makefile.			#
# 28/10/2019	MG	1.4.6	Move script_exit() before it is used.	#
#				Cannot test for existence of file with	#
#				a variable which has retained quotes,	#
#				so introduce unquoted basedirunq.	#
# 01/12/2019	MG	1.4.7	Add parallel jobs option to pass to	#
#				make as --jobs				#
# 14/04/2021	MG	1.4.8	Add menu-config option to invoke menu	#
#				of configurable options.		#
#									#
#########################################################################


##################
# Init variables #
##################

readonly version=1.4.8			# set version variable
readonly packageversion=1.3.11	# Version of the complete package

# Set defaults
atonly=""
build=false
check=false
config=false
debug=""
dist=false
distcheck=false
gnulib=false
headercheck=""
menuconfig=false
par_jobs=""
sparse=""
tarball=false
testinghacks=""
verbose=false
verboseconfig=" --enable-silent-rules=yes"
verbosemake=" --quiet"
basedir="."			# Retain quotes
basedirunq=$basedir		# Without retaining quotes
configcli_extra_args=""


#############
# Functions #
#############

# -h --help output.
# No parameters
# No return value
usage ()
{
cat << EOF
Usage:- acmbuild.sh / $0 [options] [-- configure options to pass on]
	-a or --at-only during testing and for an AutoTools-only install, some
		build changes are required. e.g. You may reference an external
		Java jar in datadir but in AT builds and installations this
		may expand to /usr/local/share... So a substitution is required
		for this scenario.
	-b or --build make the project
	-c or --config congigure the project
	-C or --distcheck perform normal distcheck
	-d or --debug build with appropriate debug flags
	-D or --dist perform a make dist
	-g or --gnulib run gnulib-tool --update
	-h or --help displays usage information
	-H or --header-check show include stack depth
	-K or --check run make check
	-m or --menu-config Invoke menu of configurable options
	-p[X] or --parallel-jobs[=X] number of jobs to pass to make as --jobs=
		If not specified make is sequential
		If no value X is given then defaults to nproc
	-s or --sparse build using sparse
	-t or --testing-hacks some build changes may be required for testing
		purposes. e.g. A script may invoke a project jar file which
		when installed will be somewhere under datadir, but during
		testing it is in the project tree.
	-T or --source-tarball create source tarball
	-v or --verbose emit extra information
	-V or --version displays version information
EOF
}

# Standard function to emit messages depending on various parameters.
# Parameters -	$1 What:-	The message to emit.
#		$2 Where:-	stdout == 0
#				stderr == 1
# No return value.
output()
{
	if (( !$2 )); then
		printf "%s\n" "$1"
	else
		printf "%s\n" "$1" 1>&2
	fi
}

# Standard function to tidy up and return exit code.
# Parameters - 	$1 is the exit code.
# No return value.
script_exit()
{
	exit $1
}

# Standard function to test command error and exit if non-zero.
# Parameters - 	$1 is the exit code, (normally $? from the preceeding command).
# No return value.
std_cmd_err_handler()
{
	if (( $1 )); then
		script_exit $1
	fi
}

# Standard trap exit function.
# No parameters.
# No return value.
trap_exit()
{
	local -i exit_code=$?
	local msg

	msg="Script terminating with exit code $exit_code due to trap received."
	output "$msg" 1
	script_exit $exit_code
}

# Setup trap
trap trap_exit SIGHUP SIGINT SIGQUIT SIGTERM

# Process command line arguments with GNU getopt.
# Parameters -	$1 is the command line.
# No return value.
proc_CL()
{
	local GETOPTTEMP
	local script_name="acmbuild.sh/bootstrap.sh"
	local tmp

	tmp="getopt -o abcCdDghHKmp::stTvV "
	tmp+="--long at-only,build,check,config,distcheck,debug,dist,gnulib"
	tmp+=",help,header-check,menu-config,parallel-jobs::,sparse"
	tmp+=",source-tarball,testing-hacks,verbose,version"
	GETOPTTEMP=$($tmp -n "$script_name" -- "$@")
	std_cmd_err_handler $?

	eval set -- "$GETOPTTEMP"
	std_cmd_err_handler $?

	while true; do
		case "$1" in
		-a|--at-only)
			atonly=" --enable-atonly=yes"
			shift
			;;
		-b|--build)
			if $distcheck || $dist || $tarball; then
				msg="Options b, C, D and T are mutually "
				msg+="exclusive."
				output "$msg" 1
				script_exit 64
			fi
			build=true
			shift
			;;
		-c|--config)
			config=true
			shift
			;;
		-C|--distcheck)
			if $build || $dist || $tarball ; then
				msg="Options b, C, D and T are mutually "
				msg+="exclusive."
				output "$msg" 1
				script_exit 64
			fi
			distcheck=true
			shift
			;;
		-d|--debug)
			debug=" --enable-debug=yes"
			shift
			;;
		-D|--dist)
			if $build || $distcheck || $tarball ; then
				msg="Options b, C, D and T are mutually "
				msg+="exclusive."
				output "$msg" 1
				script_exit 64
			fi
			dist=true
			shift
			;;
		-g|--gnulib)
			gnulib=true
			shift
			;;
		-h|--help)
			usage
			shift
			script_exit 0
			;;
		-H|--header-check)
			headercheck=" --enable-headercheck=yes"
			shift
			;;
		-K|--check)
			if $distcheck || $dist || $tarball; then
				msg="Options C, D, K and T are mutually "
				msg+="exclusive."
				output "$msg" 1
				script_exit 64
			fi
			check=true
			shift
			;;
		-m|--menu-config)
			which whiptail > /dev/null
			status=$?
			if (( $status != 0 )); then
				output "Please first install whiptail." 1
				script_exit 64
			fi
			menuconfig=true
			shift
			;;
		-p|--parallel-jobs)
			if [[ -z "$2" ]]; then
				par_jobs=" --jobs=$(nproc)"
			else
				par_jobs=" --jobs=$2"
			fi
			shift 2
			;;
		-s|--sparse)
			sparse=" --enable-sparse=yes"
			shift
			;;
		-t|--testing-hacks)
			testinghacks=" --enable-testinghacks=yes"
			shift
			;;
		-T|--source-tarball)
			if $build || $distcheck || $dist ; then
				msg="Options b, C, D and T are mutually "
				msg+="exclusive."
				output "$msg" 1
				script_exit 64
			fi
			tarball=true
			shift
			;;
		-v|--verbose)
			verbose=true
			verboseconfig=""
			verbosemake=""
			shift
			;;
		-V|--version)
			printf "Script version %s\n" $version
			printf "Package version %s\n" $packageversion
			shift
			script_exit 0
			;;
		--)	shift
			break
			;;
		*)	output "Internal error." 1
			script_exit 64
			;;
		esac
	done

	if [[ $atonly || $debug || $headercheck || $sparse || $testinghacks ]] \
		|| $verbose ; then
		if ! $config ; then
			msg="Options a, d, H, s, t and v require option c."
			output "$msg" 1
			script_exit 64
		fi
	fi

	# One option has to be selected.
	if ! $build && ! $check && ! $config && ! $distcheck && ! $dist \
		&& ! $gnulib && ! $tarball ; then
		output "Either b, c, C, D, g, K or T must be set." 1
		script_exit 64
	fi

	# menu-config can only be selected with config
	if $menuconfig && ! $config; then
		output "Option c must be selected with option m." 1
		script_exit 64
	fi

	# First non-option argument which is not an option argument is the base
	# directory, all others are passed straight to the configure command
	# line, (to support things like  --prefix=... etc). Both of these need
	# to be inputised before they are passed on in order to maintain
	# original quoting. They can then be 'eval'ed.
	if (( $# )); then
		basedir=${1@Q}
		basedirunq="$1"		# Unquoted version
		shift
		configcli_extra_args+=" "${@@Q}
	fi
}

# Process gnulib option
# No parameters.
# No return value
proc_gnulib()
{
	local cmdline
	local msg
	local status

	if [[ -f "$basedirunq/m4/gnulib-cache.m4" ]]; then
		cmdline="gnulib-tool --update"$verbosemake$verbosemake
		cmdline+=" --dir="$basedir
		eval "$cmdline"
		status=$?
		output "$cmdline completed with exit status: $status" $status
		std_cmd_err_handler $status
	else
		msg="Option -g --gnulib ignored - "
		msg+="missing $basedir/m4/gnulib-cache.m4"
		output "$msg" 0
	fi
}

# Process the configurable options menu
# No parameters
# No return value
proc_menuconfig()
{
	local msg

	if [[ ! -f $basedirunq/configurable-options.sh \
		|| ! -r $basedirunq/configurable-options.sh \
		|| ! -x $basedirunq/configurable-options.sh ]]; then
		msg="The script configurable-options.sh must; exist in the"
		msg+=" project root directory, be readable and be executable."
		output "$msg" 1
		script_exit 77
	fi
	configcli_extra_args+=$($basedirunq/configurable-options.sh)
	std_cmd_err_handler $?
}

# Process configure
# No parameters
# No return value
proc_config()
{
	local cmdline
	local msg
	local status

	cmdline="autoreconf -if $basedir"
	eval "$cmdline"
	status=$?
	msg="autoreconf -if "$basedir" completed with exit status: $status"
	output "$msg" $status
	std_cmd_err_handler $status

	cmdline="$basedir/configure$configcli_extra_args$verboseconfig"
	cmdline+="$atonly$debug$headercheck$sparse$testinghacks"

	eval "$cmdline"
	status=$?
	output "$cmdline completed with exit status: $status" $status
	std_cmd_err_handler $status
}

# Process the correct make variation.
# No parameters.
# Returns 0 or command line error.
proc_make()
{
	local cmdline
	local status

	if $build ; then
		cmdline="make"$verbosemake$par_jobs
	fi

	if $check ; then
		if [[ ! $cmdline ]]; then
			cmdline="make"$verbosemake$par_jobs
		fi
		cmdline+=" check"
	fi

	if $distcheck ; then
		cmdline="make"$verbosemake$par_jobs" distcheck clean"
	fi

	if $dist ; then
		cmdline="make"$verbosemake$par_jobs" dist clean"
	fi

	if $tarball ; then
		cmdline="make"$verbosemake$par_jobs" srctarball clean"
	fi

	# May get here with cmdline empty if, for example, only the -g option
	# was set.
	if [[ ! $cmdline ]]; then
		return 0
	fi

	eval "$cmdline"
	status=$?
	output "$cmdline completed with exit status: $status" $status
	return $status
}


########
# Main #
########

proc_CL "$@"

# Create build log.
exec 1> >(tee build-output.txt) 2>&1

# Now the main processing.
if $gnulib ; then
	proc_gnulib
fi

if $menuconfig; then
	proc_menuconfig
fi

if $config ; then
	proc_config
fi

proc_make
std_cmd_err_handler $?

script_exit 0

