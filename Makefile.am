#########################################################################
#									#
# Author: Copyright (C) 2018-2019, 2021, 2023-2026  Mark Grant		#
#									#
# Released under the GPLv3 only.					#
# SPDX-License-Identifier: GPL-3.0-only					#
#									#
# Purpose:								#
# AutoMake script file to generate dnsmasq-logrotate project.		#
#									#
#########################################################################


ACLOCAL_AMFLAGS = -I m4


AM_DISTCHECK_CONFIGURE_FLAGS = --enable-distcheckfake=yes


SUBDIRS = src/bash-comp
SUBDIRS += src/conf/rootetc/logrotate
SUBDIRS += src/man/8
SUBDIRS += src/prg/bash
SUBDIRS += src/prg/test-data/etc1
SUBDIRS += src/prg/test-data/etc2
SUBDIRS += src/prg/test-data/etc3
SUBDIRS += src/prg/test-data/etc4


doc_DATA = AUTHORS ChangeLog COPYING NEWS README


EXTRA_DIST = $(srcdir)/AUTHORS $(srcdir)/ChangeLog $(srcdir)/COPYING \
		$(srcdir)/NEWS $(srcdir)/README $(srcdir)/misc


srctarball:
	@cwd="$${PWD}" && \
	targ="$${cwd}/@PACKAGE_TARNAME@-@PACKAGE_VERSION@.tar.gz" && \
	cd @srcdir@ && \
	echo "making srctarball from @srcdir@" && \
	echo "GA	$${targ}" && \
	git archive --format=tar.gz \
		--prefix=@PACKAGE_TARNAME@-@PACKAGE_VERSION@/ \
		--output=$${targ} \
		HEAD && \
	cd -


sign_tarball:
	rm -f @PACKAGE_TARNAME@-@PACKAGE_VERSION@.tar.gz.asc
	gpg --armor --detach-sign @PACKAGE_TARNAME@-@PACKAGE_VERSION@.tar.gz

