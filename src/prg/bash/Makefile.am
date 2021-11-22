#########################################################################
#									#
# Script ID: src/prg/bash/Makefile.am					#
# Author: Copyright (C) 2018-2019, 2021  Mark Grant			#
#									#
# Released under the GPLv3 only.					#
# SPDX-License-Identifier: GPL-3.0-only					#
#									#
# Purpose:								#
# AutoMake script file to generate dnsmasq-logrotate scripts.		#
#									#
#########################################################################

#########################################################################
#									#
# Changelog								#
#									#
# Date		Author	Version	Description				#
#									#
# 24/05/2018	MG	1.0.1	First release.				#
# 03/04/2019	MG	1.0.2	Remove shebang.				#
# 22/11/2021	MG	1.0.3	Tighten SPDX tag.			#
#									#
#########################################################################


dnsmasq-postrotate.sh: Makefile
	mkdir -p $(@D)
	rm -f $@ $@.tmp
	test -f ./$@.in || srcdir=$(srcdir)/; \
	$(edit) $${srcdir}$(@F).in > $@.tmp
	mv $@.tmp $@
	chmod a+x $@
dnsmasq-postrotate.sh: $(srcdir)/dnsmasq-postrotate.sh.in


sbin_SCRIPTS = dnsmasq-postrotate.sh


EXTRA_DIST = $(srcdir)/dnsmasq-postrotate.sh.in

CLEANFILES = *.tmp dnsmasq-postrotate.sh
