#########################################################################
#									#
# Script ID: ./Makefile.am						#
# Author: Copyright (C) 2018-2019  Mark Grant				#
#									#
# Released under the GPLv3 only.					#
# SPDX-License-Identifier: GPL-3.0					#
#									#
# Purpose:								#
# AutoMake script file to generate dnsmasq-logrotate project.		#
#									#
#########################################################################

#########################################################################
#									#
# Changelog								#
#									#
# Date		Author	Version	Description				#
#									#
# 24/05/2018	MG	1.0.1	First release.				#
# 10/06/2018	MG	1.0.2	Add info messages to srctarball target.	#
# 31/10/2018	MG	1.0.3	Change srctarball target to build with	#
#				src between package name and version in	#
#				filename.				#
# 03/04/2019	MG	1.0.4	Add test-data build.			#
#				Remove shebang.				#
#									#
#########################################################################


ACLOCAL_AMFLAGS = -I m4


SUBDIRS = src/prg/bash
SUBDIRS += src/prg/test-data/etc
SUBDIRS += src/man/8
SUBDIRS += src/conf/rootetc/logrotate


srctarball:
	@cwd="$${PWD}" && \
	targ="$${cwd}/@PACKAGE_TARNAME@-src-@PACKAGE_VERSION@.tar.gz" && \
	cd @srcdir@ && \
	echo "making srctarball from @srcdir@" && \
	echo "GA	$${targ}" && \
	git archive --format=tar.gz \
		--prefix=@PACKAGE_TARNAME@-@PACKAGE_VERSION@/ \
		--output=$${targ} \
		HEAD && \
	cd -

