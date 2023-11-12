#########################################################################
#									#
# Author: Copyright (C) 2018-2019, 2021, 2023  Mark Grant		#
#									#
# Released under the GPLv3 only.					#
# SPDX-License-Identifier: GPL-3.0-only					#
#									#
# Purpose:								#
# AutoMake script file to generate dnsmasq-logrotate manual pages.	#
#									#
#########################################################################


dnsmasq-postrotate.8: Makefile
	mkdir -p $(@D)
	rm -f $@ $@.tmp
	$(edit) $(srcdir)/$(@F).man.in > $@.tmp
	targfile=$(@F);	\
	if [[ $$targfile == *"."* ]]; then \
		if [[ $${targfile##*.} == "" ]]; then \
			echo "Source file suffix used as section but empty."; \
			exit 1; \
		else \
			section=$${targfile##*.}; \
		fi; \
	else \
		echo "Source file suffix used as section but no dot & empty."; \
		exit 1; \
	fi; \
	txt2manwrap $(@F) $$section "dnsmasq-logrotate Manual" $@.tmp $@
	rm -f $@.tmp

dnsmasq-postrotate.8: $(srcdir)/dnsmasq-postrotate.8.man.in

man_MANS = dnsmasq-postrotate.8

EXTRA_DIST = $(srcdir)/dnsmasq-postrotate.8.man.in

CLEANFILES = *.tmp dnsmasq-postrotate.8
