#########################################################################
#									#
# Author: Copyright (C) 2026  Mark Grant				#
#									#
# Released under the GPLv3 only.					#
# SPDX-License-Identifier: GPL-3.0-only					#
#									#
# Purpose:								#
# AutoMake script file to generate tests.				#
#									#
#########################################################################


run-dot-sh-dot-in-pattern.sh shellcheck-dot-xx-dot-in-pattern.sh \
	shellcheck-inline-dot-sh.sh: Makefile
	mkdir -p $(@D)
	rm -f $@ $@.tmp
	test -f ./$@.in || srcdir=$(srcdir)/; \
	$(edit) $${srcdir}$(@).in > $@.tmp
	mv $@.tmp $@
	chmod a+x $@
run-dot-sh-dot-in-pattern.sh: $(srcdir)/run-dot-sh-dot-in-pattern.sh.in
shellcheck-dot-xx-dot-in-pattern.sh: \
	$(srcdir)/shellcheck-dot-xx-dot-in-pattern.sh.in
shellcheck-inline-dot-sh.sh: $(srcdir)/shellcheck-inline-dot-sh.sh.in


check_DATA = run-dot-sh-dot-in-pattern.sh shellcheck-dot-xx-dot-in-pattern.sh \
	     shellcheck-inline-dot-sh.sh


EXTRA_DIST =  $(srcdir)/run-dot-sh-dot-in-pattern.sh.in \
	      $(srcdir)/shellcheck-dot-xx-dot-in-pattern.sh.in \
	      $(srcdir)/shellcheck-inline-dot-sh.sh.in


CLEANFILES = *.tmp run-dot-sh-dot-in-pattern.sh \
	     shellcheck-dot-xx-dot-in-pattern.sh shellcheck-inline-dot-sh.sh

