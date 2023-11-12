#! /bin/bash
#########################################################################
#									#
#	bootstrap.sh is automatically generated,			#
#		please do not modify!					#
#									#
#########################################################################

#########################################################################
#									#
# Author: Copyright (C) 2014-2019, 2021-2023  Mark Grant		#
#									#
# Released under the GPLv3 only.					#
# SPDX-License-Identifier: GPL-3.0-only					#
#									#
# Purpose:								#
# To simplify the AutoTools distribution build.				#
#									#
# Syntax:	See usage().						#
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


set -o pipefail


##################
# Init variables #
##################

readonly version=1.6.0			# set version variable
readonly packageversion=1.6.2	# Version of the complete package

# Set defaults
atonly=""
analyzer=""
build=false
cc=""
cc_cli=""
check=false
config=false
debug=""
dist=false
distcheck=false
gnulib=false
headercheck=""
iwyu=""
menuconfig=false
par_jobs=""
scan_build=""
sparse=""
tarball=false
testinghacks=""
verbose=false
verboseconfig=" --enable-silent-rules=yes"
verbosemake=" --quiet"
basedir="."			# Retain quotes
basedirunq=$basedir		# Without retaining quotes
configcli_extra_args=()


#############
# Functions #
#############

# -h --help output.
# No parameters
# No return value
usage()
{
cat << EOF
Usage is also true for acmbuild
Usage is:-
${0##*/} -b [-c [-a] [-A] [{--CC=COMPILER|-s}] [-d] [-H] [-m] [-t] [-v]]
		[-g] [-K] [-pX] [-- PASS_THRU_OPTIONS ...]
${0##*/} -c [-a] [-A] [{--CC=COMPILER|-s}] [-d] [-H] [-m] [-pX] [-t] [-v]
		[-- PASS_THRU_OPTIONS ...]
${0##*/} -c {-i|-S} [--CC=COMPILER] [-pX] [-v] [-- PASS_THRU_OPTIONS ...]
${0##*/} {-C|-D|-T} [-c] [-g] [-pX] [-- PASS_THRU_OPTIONS ...]
${0##*/} -g [-b]
		[-c [-a] [-A] [{--CC=COMPILER|-s}] [-d] [-H] [-m] [-t] [-v]]
		[-K] [-pX] [-- PASS_THRU_OPTIONS ...]
${0##*/} {-h|-V}
${0##*/} -K [-b]
		[-c [-a] [-A] [{--CC=COMPILER|-s}] [-d] [-H] [-m] [-t] [-v]]
		[-g] [-pX] [-- PASS_THRU_OPTIONS ...]

Usage is:-
${0##*/} [OPTIONS] [-- PASS_THRU_OPTIONS ...]
	-a or --at-only during testing and for an AutoTools-only install, some
		build changes are required. e.g. You may reference an external
		Java jar in datadir but in AT builds and installations this
		may expand to /usr/local/share... So a substitution is required
		for this scenario.
	-A or --analyzer enable compiler analyzer output
	-b or --build make the project
	-c or --config congigure the project
	-C or --distcheck perform normal distcheck
	      --CC=compiler Compiler to use, eg gcc, clang etc
	-d or --debug build with appropriate debug flags
	-D or --dist perform a make dist
	-g or --gnulib run gnulib-tool --update
	-h or --help displays usage information
	-H or --header-check show include stack depth
	-i or --iwyu Use clang's include-what-you-use
	-K or --check run make check
	-m or --menu-config Invoke menu of configurable options
	-p[X] or --parallel-jobs[=X] number of jobs to pass to make as --jobs=
		If not specified make is sequential
		If no value X is given then defaults to nproc
	-s or --sparse build using sparse
	-S or --scan-build Use clang's scan-build static analyser
	-t or --testing-hacks some build changes may be required for testing
		purposes. e.g. A script may invoke a project jar file which
		when installed will be somewhere under datadir, but during
		testing it is in the project tree.
	-T or --source-tarball create source tarball
	-v or --verbose emit extra information
	-V or --version displays version information

	-- PASS_THRU_OPTIONS The -- stops processing command line arguments and
		instead passes subsequent arguments on, as-is, to AutoTools
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
	exit "$1"
}

# Standard function to test command error and exit if non-zero.
# Parameters - 	$1 is the exit code, (normally $? from the preceeding command).
# No return value.
std_cmd_err_handler()
{
	if (( $1 )); then
		script_exit "$1"
	fi
}

# Standard trap exit function.
# No parameters.
# No return value.
# shellcheck disable=SC2317  # Do not warn about unreachable commands in trap
# functions, they are legitimate.
trap_exit()
{
	local -i exit_code=$?
	local msg

	msg="Script terminating with exit code $exit_code due to trap received."
	output "$msg" 1
	script_exit "$exit_code"
}

# Setup trap
trap trap_exit SIGHUP SIGINT SIGQUIT SIGTERM

# Process command line arguments with GNU getopt.
# Parameters -	$1 is the command line.
# No return value.
proc_CL()
{
	local GETOPTTEMP
	local script_name="acmbuild/bootstrap.sh"
	local tmp

	tmp="getopt -o aAbcCdDghHiKmp::sStTvV "
	tmp+="--long at-only,analyzer,build,CC:,check,config,distcheck,debug"
	tmp+=",dist,gnulib,help,header-check,iwyu,menu-config,parallel-jobs::"
	tmp+=",sparse,scan-build,source-tarball,testing-hacks,verbose,version"
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
		-A|--analyzer)
			analyzer=" --enable-analyzer=yes"
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
		--CC)
			cc="$2"
			cc_cli=" CC=$2"
			shift 2
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
		-i| --iwyu)
			iwyu=" --enable-iwyu=yes"
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
			if (( status != 0 )); then
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
		-S| --scan-build)
			scan_build=" --enable-scan-build=yes"
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

	if [[ $atonly || $analyzer || $cc || $debug || $headercheck \
		|| $iwyu || $sparse || $scan_build || $testinghacks ]] \
		|| $verbose ; then
		if ! $config ; then
			msg="Options a, A, CC, d, H, i, s, S, t and v require"
			msg+=" option c."
			output "$msg" 1
			script_exit 64
		fi
	fi

	# include-what-you-use cannot be used with a number of other options.
	if [[ $atonly || $analyzer || $debug || $headercheck || $scan_build \
		|| $sparse || $testinghacks ]] || $build || $check || $dist \
		|| $distcheck || $gnulib || $menuconfig || $tarball ; then
		if [[ $iwyu ]]; then
			msg="Options a, A, b, C, d, D, g, H, k, m, s, S, t and"
			msg+=" T cannot be used with option i"
			output "$msg" 1
			script_exit 64
		fi
	fi

	# scan-build cannot be used with a number of other options.
	if [[ $atonly || $analyzer || $debug || $headercheck || $iwyu \
		|| $sparse || $testinghacks ]] || $build || $check || $dist \
		|| $distcheck || $gnulib || $menuconfig || $tarball ; then
		if [[ $scan_build ]] ; then
			msg="Options a, A, b, C, d, D, g, H, i, k, m, s, t"
			msg+=" and T cannot be used with option S"
			output "$msg" 1
			script_exit 64
		fi
	fi

	# Sparse and CC conflict, both setting the CC variable.
	if [[ $cc && $sparse ]]; then
		msg="Options CC and s are mutually exclusive."
		output "$msg" 1
		script_exit 64
	fi

	# include-what-you-use needs clang as compiler.
	if [[ $iwyu && -z $cc ]]; then
		cc="clang"
		cc_cli=" CC=clang"
	fi

	# One option has to be selected.
	if ! $build && ! $check && ! $config && ! $distcheck && ! $dist \
		&& ! $gnulib && ! $tarball \
		&& [[ ! $iwyu || ! $scan_build ]]; then
		output "Either b, c, C, D, g, i, K, S  or T must be set." 1
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
		configcli_extra_args+=( ' ' "$@" )
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
	local tmp_extra_args=()
	local tmp_file
	tmp_file=/tmp/$$.$(basename "$0").tmp
	readonly tmp_file

	if [[ ! -f $basedirunq/configurable-options.sh \
		|| ! -r $basedirunq/configurable-options.sh \
		|| ! -x $basedirunq/configurable-options.sh ]]; then
		msg="The script configurable-options.sh must; exist in the"
		msg+=" project root directory, be readable and be executable."
		output "$msg" 1
		script_exit 77
	fi
	"$basedirunq"/configurable-options.sh "$tmp_file"
	std_cmd_err_handler $?
	mapfile -t tmp_extra_args < <( head -n 1 "$tmp_file" )
	std_cmd_err_handler $?
	configcli_extra_args+=( "${tmp_extra_args[@]}" )
	std_cmd_err_handler $?
	rm -f "$tmp_file"
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
	msg="autoreconf -if $basedir completed with exit status: $status"
	output "$msg" $status
	std_cmd_err_handler $status

	cmdline="$basedir/configure$cc_cli${configcli_extra_args[*]}"
	cmdline+="$verboseconfig$atonly$analyzer$debug$headercheck$iwyu$sparse"
	cmdline+="$scan_build$testinghacks"

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

	if [[ $iwyu ]]; then
		cmdline="make"$verbosemake$par_jobs" -k"
		cmdline+=" CC=include-what-you-use"
	fi

	if [[ $scan_build ]]; then
		if [[ $cc ]]; then
			cmdline="scan-build --use-cc=$cc make"$verbosemake
			cmdline+=$par_jobs" -k"
		else
			cmdline="scan-build make"$verbosemake$par_jobs" -k"
		fi
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

# Now the main processing.
if $menuconfig; then
	proc_menuconfig
fi

# Create build log after menuconfig which may use dialog and redirections.
exec 1> >(tee build-output.txt) 2>&1

if $gnulib ; then
	proc_gnulib
fi

if $config ; then
	proc_config
fi

proc_make
std_cmd_err_handler $?

script_exit 0

