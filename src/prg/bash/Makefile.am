#########################################################################
#									#
# Author: Copyright (C) 2018-2019, 2021, 2023  Mark Grant		#
#									#
# Released under the GPLv3 only.					#
# SPDX-License-Identifier: GPL-3.0-only					#
#									#
# Purpose:								#
# AutoMake script file to generate dnsmasq-logrotate scripts.		#
#									#
#########################################################################


dnsmasq-postrotate: Makefile
	mkdir -p $(@D)
	rm -f $@ $@.tmp
	test -f ./$@.in || srcdir=$(srcdir)/; \
	$(edit) $${srcdir}$(@F).sh.in > $@.tmp
	mv $@.tmp $@
	chmod a+x $@
dnsmasq-postrotate: $(srcdir)/dnsmasq-postrotate.sh.in


sbin_SCRIPTS = dnsmasq-postrotate


EXTRA_DIST = $(srcdir)/dnsmasq-postrotate.sh.in

CLEANFILES = *.tmp dnsmasq-postrotate
