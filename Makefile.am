#! /usr/bin/env bash
#########################################################################
#									#
# Script ID: ./Makefile.am						#
# Author: Copyright (C) 2018  Mark Grant				#
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
#									#
#########################################################################


ACLOCAL_AMFLAGS = -I m4


SUBDIRS = src/prg/bash
SUBDIRS += src/man/8
SUBDIRS += src/conf/rootetc/logrotate


srctarball:
	@cwd="$${PWD}" && \
	cd @srcdir@ && \
	echo "making srctarball from @srcdir@" && \
	echo "GA	@builddir@/@PACKAGE_TARNAME@-@PACKAGE_VERSION@.tar.gz" \
	&& \
	git archive --format=tar.gz \
		--prefix=@PACKAGE_TARNAME@-@PACKAGE_VERSION@/ \
		--output=$${cwd}/@PACKAGE_TARNAME@-@PACKAGE_VERSION@.tar.gz \
		HEAD && \
	cd -
