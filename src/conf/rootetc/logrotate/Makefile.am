#########################################################################
#									#
# Author: Copyright (C) 2018-2019, 2021, 2023  Mark Grant		#
#									#
# Released under the GPLv3 only.					#
# SPDX-License-Identifier: GPL-3.0-only					#
#									#
# Purpose:								#
# AutoMake script file to install dnsamasq logrotate.d file.		#
# Must be installed in /etc/logrotate.d as it is for use by the		#
# logrotate program.							#
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
