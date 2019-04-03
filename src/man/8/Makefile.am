#########################################################################
#									#
# Script ID: src/man/8/Makefile.am					#
# Author: Copyright (C) 2018-2019  Mark Grant				#
#									#
# Released under the GPLv3 only.					#
# SPDX-License-Identifier: GPL-3.0					#
#									#
# Purpose:								#
# AutoMake script file to generate dnsmasq-logrotate manual pages.	#
#									#
#########################################################################

#########################################################################
#									#
# Changelog								#
#									#
# Date		Author	Version	Description				#
#									#
# 25/05/2018	MG	1.0.1	First release.				#
# 03/04/2019	MG	1.0.2	Remove shebang.				#
#									#
#########################################################################


dnsmasq-postrotate.sh.8: Makefile
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

dnsmasq-postrotate.sh.8: $(srcdir)/dnsmasq-postrotate.sh.8.man.in

man_MANS = dnsmasq-postrotate.sh.8

EXTRA_DIST = $(srcdir)/dnsmasq-postrotate.sh.8.man.in

CLEANFILES = *.tmp dnsmasq-postrotate.sh.8
