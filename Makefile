#
# Copyright (c) 2001 Tama Communications Corporation
#
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
MANUAL=	globaldoc
FILES=	global.in whatsnew.in ${MANUAL}_toc.in license.in links.in \
	plans.in contribute.in maillist.in download.in
HTMLS=	global.html whatsnew.html ${MANUAL}_toc.html license.html links.html \
	plans.html contribute.html maillist.html download.html

TUTOR=	${MANUAL}_toc.in ${MANUAL}.html
IMAGE=	globe.png sglobe.png

all: ${HTMLS} ${MANUAL}.html

${HTMLS}: makehtml.pl ${FILES} ${TUTOR}
	@./makehtml.pl -v ${FILES}

${TUTOR}: global.txi version.texi reference.txi fdl.txi gctags.ref global.ref gtags.ref htags.ref
	@echo "Generating ${MANUAL}.html and ${MANUAL}_toc.html ..."
	@cp global.txi ${MANUAL}.txi
	@texi2html -number ${MANUAL}.txi
	@echo "Generating ${MANUAL}_toc.in ..."
	@echo "@title Tutorial" > ${MANUAL}_toc.in
	@echo "@link Tutorial" >> ${MANUAL}_toc.in
	@echo "@body" >> ${MANUAL}_toc.in
	@sed -e '1,/^<BODY.*>/d' -e '/<\/BODY.*>/,$$d' < ${MANUAL}_toc.html >> ${MANUAL}_toc.in
	@rm -f ${MANUAL}.txi
clean:
	rm -f ${HTMLS} ${TUTOR}
