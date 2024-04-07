#########################################################################
#									#
# Author: Copyright (C) 2024  Mark Grant				#
#									#
# Released under the GPLv3 only.					#
# SPDX-License-Identifier: GPL-3.0-only					#
#									#
# Purpose:								#
# AutoMake script file to generate dnsmasq-logrotate test-data.		#
#									#
#########################################################################


dnsmasq.conf Testing.txt dnsmasq.d/mg.conf dnsmasq.d/mg0.conf dnsmasq.d/README \
	dnsmasq.d/test.dpkg-dist dnsmasq.d/level1/mg1.conf \
	dnsmasq.d/level1/level2/mg2.conf \
	dnsmasq.d/level1/level2/level3/mg3.conf \
	logrotate.d/dnsmasq: Makefile
	mkdir -p $(@D)
	rm -f $@ $@.tmp
	test -f ./$@.in || srcdir=$(srcdir)/; \
	$(edit) $${srcdir}$(@).in > $@.tmp
	mv $@.tmp $@
	chmod a+x $@
dnsmasq.conf: $(srcdir)/dnsmasq.conf.in
Testing.txt: $(srcdir)/Testing.txt.in
dnsmasq.d/mg.conf: $(srcdir)/dnsmasq.d/mg.conf.in
dnsmasq.d/mg0.conf: $(srcdir)/dnsmasq.d/mg0.conf.in
dnsmasq.d/README: $(srcdir)/dnsmasq.d/README.in
dnsmasq.d/test.dpkg-dist: $(srcdir)/dnsmasq.d/test.dpkg-dist.in
dnsmasq.d/level1/mg1.conf: $(srcdir)/dnsmasq.d/level1/mg1.conf.in
dnsmasq.d/level1/level2/mg2.conf: $(srcdir)/dnsmasq.d/level1/level2/mg2.conf.in
dnsmasq.d/level1/level2/level3/mg3.conf: \
			$(srcdir)/dnsmasq.d/level1/level2/level3/mg3.conf.in
logrotate.d/dnsmasq: $(srcdir)/logrotate.d/dnsmasq.in


clean-local:
	rm -rf ./dnsmasq.d ./logrotate.d


check_DATA = dnsmasq.conf Testing.txt dnsmasq.d/mg.conf dnsmasq.d/mg0.conf \
	     dnsmasq.d/README dnsmasq.d/test.dpkg-dist \
	     dnsmasq.d/level1/mg1.conf dnsmasq.d/level1/level2/mg2.conf \
	     dnsmasq.d/level1/level2/level3/mg3.conf logrotate.d/dnsmasq


EXTRA_DIST = $(srcdir)/dnsmasq.conf.in $(srcdir)/Testing.txt.in \
	     $(srcdir)/dnsmasq.d/mg.conf.in $(srcdir)/dnsmasq.d/mg0.conf.in \
	     $(srcdir)/dnsmasq.d/README.in \
	     $(srcdir)/dnsmasq.d/test.dpkg-dist.in \
	     $(srcdir)/dnsmasq.d/level1/mg1.conf.in \
	     $(srcdir)/dnsmasq.d/level1/level2/mg2.conf.in \
	     $(srcdir)/dnsmasq.d/level1/level2/level3/mg3.conf.in \
	     $(srcdir)/logrotate.d/dnsmasq.in


CLEANFILES = *.tmp dnsmasq.conf Testing.txt

