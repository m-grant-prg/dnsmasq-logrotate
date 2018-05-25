#! /usr/bin/env bash
#########################################################################
#									#
# Script ID: src/conf/rootetc/logrotate/Makefile.am			#
# Author: Copyright (C) 2018  Mark Grant				#
#									#
# Released under the GPLv3 only.					#
# SPDX-License-Identifier: GPL-3.0					#
#									#
# Purpose:								#
# AutoMake script file to install dnsamasq logrotate.d file.		#
# Must be installed in /etc/logrotate.d as it is for use by the		#
# logrotate program.							#
#									#
#########################################################################

#########################################################################
#									#
# Changelog								#
#									#
# Date		Author	Version	Description				#
#									#
# 24/05/2018	MG	1.0.1	First release.				#
#									#
#########################################################################

# logrotateloc is set in configure.ac to provide a conditional target depending
# on whether distcheck is being run.

confdir = $(logrotateloc)

dnsmasq: Makefile
	mkdir -p $(@D)
	rm -f $@ $@.tmp
	test -f ./$@.in || srcdir=$(srcdir)/; \
	$(edit) $${srcdir}$(@F).in > $@.tmp
	mv $@.tmp $@
dnsmasq: $(srcdir)/dnsmasq.in

conf_DATA = dnsmasq

EXTRA_DIST = $(srcdir)/dnsmasq.in

CLEANFILES = *.tmp dnsmasq
