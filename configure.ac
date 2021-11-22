#########################################################################
#									#
# Script ID: ./configure.ac						#
# Author: Copyright (C) 2018-2021  Mark Grant				#
#									#
# Released under the GPLv3 only.					#
# SPDX-License-Identifier: GPL-3.0-only					#
#									#
# Purpose:								#
# AutoConf script file to configure dnsmasq-logrotate project.		#
#									#
# configure cmd line syntax:						#
# ./configure	[--enable-distcheckfake=<yes|no> [default: no]]		#
#									#
# Parameters generic description. For specifics to this configure.ac	#
# please see inline comments at the point of definition:-		#
# --enable-distcheckfake						#
#	Enables the replacement of an absolute directory path specified	#
#	in a variable, with a value based on AutoTools standard		#
#	directories. This enables the Makefile.am to use the AT		#
#	variable based value when running distcheck and the absolute	#
#	path for all else. Hence distcheck can now succeed when it	#
#	would normally fail.						#
#									#
# Layout: (Only relevant sections will exist).				#
# ChangeLog : High level ChangeLog					#
# SECTION  1: Initialisation & Setup					#
# SECTION  2: Architecture, target and host checks			#
# SECTION  3: Command line arguments					#
# SECTION  4: Compiler setup						#
# SECTION  5: Check for programs					#
# SECTION  6: Check for libraries					#
# SECTION  7: Check for header files					#
# SECTION  8: Check for types						#
# SECTION  9: Check for structures					#
# SECTION 10: Check for compiler characteristics			#
# SECTION 11: Check for library functions				#
# SECTION 12: Check for pkg-config files				#
# SECTION 13: Check for system services					#
# SECTION 14: Additional checks & variables				#
# SECTION 15: Specify the output files					#
#									#
#########################################################################

#########################################################################
#									#
# ChangeLog								#
#									#
# Date		Author	Version	Description				#
#									#
# 24/05/2018	MG	1.0.1	First release.				#
# 29/05/2018	MG	1.0.2	Add logger check for syslog entries.	#
# 22/12/2018	MG	1.0.3	Re-vamp to new standard layout.		#
# 03/04/2019	MG	1.0.4	Add test-data build.			#
#				Remove leading v from package version.	#
#				Pass bash path to scripts and Makefiles	#
# 10/08/2019	MG	1.0.5	Improve configure CLA description in	#
#				header comments above.			#
#				Correct AC_MSG_NOTICE texts.		#
#				Correct ARG_ENABLE help text.		#
# 22/11/2021	MG	1.0.6	If git is available and we are inside a	#
#				git tree then use git describe to add	#
#				further package version information.	#
#				Tighten SPDX tag.			#
#				Add AC_COPYRIGHT macro.			#
#									#
#########################################################################


#########################################
#					#
# SECTION  1: Initialisation & Setup	#
#					#
#########################################

AC_COPYRIGHT([Copyright (C) 2018-2021  Mark Grant
	      This script is free to copy or distribute under the terms set out
	      in the package license. See COPYING for details.])

AC_REVISION([$Revision: 1.0.6 $])

AC_PREREQ([2.69])

#
# The following macro uses git, if available, to provide versioning information.
# The logic is as follows:-
# If git is not available, is not initialised or no commit has been made, then
# the local variable pkg_version will be used.
# If git is available but no Tag has been created then just a commit identifier
# will be used.
# If git is available and a tag has been created then the most recent tag, plus
# number of commits since the tag, plus a commit identifier will be used.
# The package version in ac init will be used to create an output variable which
# can be used by ac output and / or the sed setup below to substitute bookmarks
# in source files.
#
# Set pkg_version for a default hard-coded version number.
m4_define(pkg_version, 1.0.13)

AC_INIT([Logrotate for dnsmasq], m4_esyscmd([ \
	git describe --always 1>/dev/null 2>/dev/null \
	&& sed --help 1>/dev/null 2>/dev/null \
	&& git describe --always | sed 's/v//' | tr -d '\n' \
	|| echo pkg_version | tr -d '\n']),
	[m.grant.prg@gmail.com], [dnsmasq-logrotate])

AC_MSG_NOTICE(initialisation and setup)

AC_SUBST(pkgversion, $PACKAGE_VERSION)

#
# Passes the options to all am files. Puts objects in the sub-directory
# containing the source. Forces tar to use --format=posix in make dist.
# This also checks :-	BSD install	make variable set	mkdir -p
#			gawk
#
AM_INIT_AUTOMAKE(-Wall -Werror subdir-objects tar-pax)

#
# Standard macros will be automatically placed in m4.
# Programmer defined macros should be placed in, say, m4extra which allows us
# to exclude the standard macros from being git tracked. This other directory
# must be specified as an include option in the Makefile.am ACLOCAL_AMFLAGS
# e.g.
# ACLOCAL_AMFLAGS = -I m4 -I m4extra
#
AC_CONFIG_MACRO_DIR(m4)


#########################################
#					#
# SECTION  3: Command line arguments	#
#					#
#########################################

AC_MSG_NOTICE(processing command line arguments)

#
# If a file location has to be fixed, e.g. /etc/foo.conf and never
# /usr/local/etc/foo.conf, then make distcheck will fail. Setting this flag
# allows make distcheck to locate the file in an AT standard directory-based
# location.
# eg /usr/local/etc/foo.conf.
# and hence succeed.
#
AC_ARG_ENABLE(distcheckfake,
	AS_HELP_STRING([--enable-distcheckfake], [enable running of distcheck]),
	[case "${enableval}" in
		yes) distcheckfake=true ;;
		no)  distcheckfake=false ;;
		*) AC_MSG_ERROR(bad value ${enableval} for \
			--enable-distcheckfake) ;;
	esac],distcheckfake=false)
AM_CONDITIONAL(DISTCHECKFAKE, test x$distcheckfake = xtrue)

if test "x${distcheckfake}" = xtrue; then
	AC_SUBST(logrotateloc, "$sysconfdir/logrotate.d")
	AC_MSG_NOTICE(using substitute paths to facilitate distcheck)
else
	AC_SUBST(logrotateloc, "/etc/logrotate.d")
	AC_MSG_NOTICE(using distcheck incompatible absolute based paths)
fi


#########################################
#					#
# SECTION  5: Check for programs	#
#					#
#########################################

AC_MSG_NOTICE(checking for basic programs that have AutoConf checks)

#
# The small set of tools you can expect to find on any machine.
#
# awk		date		grep		od
# basename	diff		join		rm
# cat		dirname		ln		rmdir
# cc		egrep		ls		sed
# chgrp		expr		mkdir		sleep
# chown		expr (‘|’)	mkfifo		sort
# chmod		expr (‘:’)	mknod		tar
# cmp		fgrep		mktemp		touch
# cp		find		mv		tr
#
# (For further information including limitations to the above, see Section 11.15
# in the GNU AutoConf Manual).
#
# If using am init automake, gl early or lt init the following programs are
# automatically checked:-
#
# am init automake
#	BSD install	mkdir -p	gawk
#
# gl early
#	ar	grep	egrep	ranlib
#
# lt init
#	fgrep	ranlib	sed
#
# Basic and AutoTools program checks.
#
AC_PROG_AWK
AC_PROG_EGREP
AC_PROG_FGREP
AC_PROG_GREP
AC_PROG_LN_S
AC_PROG_MKDIR_P
AC_PROG_SED

AC_MSG_NOTICE(checking for some standard AutoTools required programs)
AC_PROG_INSTALL

AC_MSG_NOTICE(checking for particular programs required by this build)
AC_CHECK_PROG(TAR, tar, yes, no)
if test "x$TAR" = "xno" ; then
	AC_MSG_ERROR(tar not found)
fi

AC_CHECK_PROG(TXT2MAN, txt2man, yes, no)
if test "x$TXT2MAN" = "xno" ; then
   	AC_MSG_ERROR(txt2man not found)
fi

AC_CHECK_PROG(TXT2MANWRAP, txt2manwrap, yes, no)
if test "x$TXT2MANWRAP" = "xno" ; then
   	AC_MSG_ERROR(txt2manwrap not found)
fi

AC_MSG_NOTICE(checking for particular programs required at build and run time)
AC_PATH_PROG(BASH, bash, no)
if test "x$BASH" = "xno" ; then
	AC_MSG_ERROR(bash not found)
fi

AC_MSG_NOTICE(checking for particular programs required at run time)
AC_CHECK_PROG(ECHO, echo, yes, no)
if test "x$ECHO" = "xno" ; then
	AC_MSG_WARN(echo not found - needed at run time)
fi

AC_CHECK_PROG(PRINTF, printf, yes, no)
if test "x$PRINTF" = "xno" ; then
	AC_MSG_WARN(printf not found - needed at run time)
fi

AC_CHECK_PROG(PS, ps, yes, no)
if test "x$PS" = "xno" ; then
	AC_MSG_WARN(ps not found - needed at run time)
fi

AC_CHECK_PROG(KILL, kill, yes, no)
if test "x$KILL" = "xno" ; then
   	AC_MSG_WARN(kill not found - needed at run time)
fi

AC_CHECK_PROG(FIND, find, yes, no)
if test "x$FIND" = "xno" ; then
   	AC_MSG_WARN(find not found - needed at run time)
fi

AC_CHECK_PROG(GETOPT, getopt, yes, no)
if test "x$GETOPT" = "xno" ; then
	AC_MSG_WARN(getopt not found - needed at run time)
fi

AC_CHECK_PROG(LOGGER, logger, yes, no)
if test "x$LOGGER" = "xno" ; then
   	AC_MSG_WARN(logger not found - needed at run time)
fi

AC_CHECK_PROG(DNSMASQ, dnsmasq, yes, no)
if test "x$DNSMASQ" = "xno" ; then
   	AC_MSG_WARN(dnsmasq not found - needed at run time)
fi


#################################################
#						#
# SECTION 14: Additional checks & variables	#
#						#
#################################################

AC_MSG_NOTICE(processing additional checks and variables)

#
# Now set up a sed sequence to substitute bookmarks in script files with either
# standard GNU Directory Variables, or with programmer-defined variables set up
# using an AC_SUBST macro above. This sed sequence will be invoked at programmer
# discretion at sub-directory Makefile.am level.
# ----------------------
#
# prefix	/usr/local (typically)
#	exec_prefix	${prefix}
#		bindir	${exec_prefix}/bin	user executables
#		sbindir	${exec_prefix}/sbin	system admin executables
#		libexecdir	${exec_prefix}/libexec	program executables
#		libdir	${exec_prefix}/lib	object code libraries
#	sysconfdir	${prefix}/etc	read-only single-machine data
#	sharedstatedir	${prefix}/com	modifiable architecture-independent data
#	localstatedir	${prefix}/var	modifiable single-machine data
#	runstatedir	${localstatedir}/run
#	includedir	${prefix}/include	C header files
#	oldincludedir	$usr/include	C header files
#	datarootdir	${prefix}/share	read-only arch.-independent data root
#		localedir	${datarootdir}/locale	locale-dependent data
#		datadir	${datarootdir}	read-only architecture-independent data
#		mandir	${datarootdir}/man	man documentation
#		infodir	${datarootdir}/info	info documentation
#		docdir	${datarootdir}/doc/${PACKAGE}	documentation root
#			htmldir	${docdir}	html documentation
#			dvidir	${docdir}	dvi documentation
#			pdfdir	${docdir}	pdf documentation
#			psdir	${docdir}	ps documentation
#		lispdir	${datarootdir}/emacs/site-lisp
#	pkgdatadir	${datarootdir}/${PACKAGE}
#	pkgincludedir	${includedir}/${PACKAGE}
#	pkglibdir	${libdir}/${PACKAGE}
#	pkglibexecdir	${libexecdir}/${PACKAGE}
#
AC_SUBST([edit], ["$SED \
		-e 's|@bashlocation[@]|\$(BASH)|g' \
		-e 's|@logrotateloc[@]|\$(logrotateloc)|g' \
		-e 's|@pkgversion[@]|\$(pkgversion)|g' \
		-e 's|@prefix[@]|\$(prefix)|g' \
		-e 's|@exec_prefix[@]|\$(exec_prefix)|g' \
		-e 's|@bindir[@]|\$(bindir)|g' \
		-e 's|@sbindir[@]|\$(sbindir)|g' \
		-e 's|@libexecdir[@]|\$(libexecdir)|g' \
		-e 's|@libdir[@]|\$(libdir)|g' \
		-e 's|@sysconfdir[@]|\$(sysconfdir)|g' \
		-e 's|@sharedstatedir[@]|\$(sharedstatedir)|g' \
		-e 's|@localstatedir[@]|\$(localstatedir)|g' \
		-e 's|@runstatedir[@]|\$(runstatedir)|g' \
		-e 's|@includedir[@]|\$(includedir)|g' \
		-e 's|@oldincludedir[@]|\$(oldincludedir)|g' \
		-e 's|@datarootdir[@]|\$(datarootdir)|g' \
		-e 's|@localedir[@]|\$(localedir)|g' \
		-e 's|@datadir[@]|\$(datadir)|g' \
		-e 's|@mandir[@]|\$(mandir)|g' \
		-e 's|@infodir[@]|\$(infodir)|g' \
		-e 's|@docdir[@]|\$(docdir)|g' \
		-e 's|@htmldir[@]|\$(htmldir)|g' \
		-e 's|@dvidir[@]|\$(dvidir)|g' \
		-e 's|@pdfdir[@]|\$(pdfdir)|g' \
		-e 's|@psdir[@]|\$(psdir)|g' \
		-e 's|@lispdir[@]|\$(lispdir)|g' \
		-e 's|@pkgdatadir[@]|\$(pkgdatadir)|g' \
		-e 's|@pkgincludedir[@]|\$(pkgincludedir)|g' \
		-e 's|@pkglibdir[@]|\$(pkglibdir)|g' \
		-e 's|@pkglibexecdir[@]|\$(pkglibexecdir)|g'"])


#########################################
#					#
# SECTION 15: Specify the output files	#
#					#
#########################################

AC_MSG_NOTICE(processing output files)

#
# Non-Makefile files to generate.
# AC_CONFIG_FILES should not be used to substitute AutoConf Installation
# Directory Variables, (bindir and friends), except in Makefiles and pkg-config
# files. See GNU AutoConf manual section 4.8.2 Installation Directory Variables.
#

# Project Makefiles to create.
AC_CONFIG_FILES([Makefile
		src/prg/bash/Makefile
		src/prg/test-data/etc/Makefile
		src/man/8/Makefile
		src/conf/rootetc/logrotate/Makefile])

AC_OUTPUT

