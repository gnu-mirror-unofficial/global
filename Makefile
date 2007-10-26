#
# Copyright (c) 2001, 2007 Tama Communications Corporation
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
	plans.in bugs.in contribute.in maillist.in download.in \
	model.in donation.in
HTMLS=	global.html whatsnew.html ${MANUAL}_toc.html license.html links.html \
	plans.html bugs.html contribute.html maillist.html download.html \
	model.html donation.html

TUTOR=	${MANUAL}_toc.in ${MANUAL}.html
IMAGE=	globe.png sglobe.png

all: ${HTMLS} ${MANUAL}.html

${HTMLS}: makehtml.pl ${FILES} ${TUTOR}
	@./makehtml.pl -v ${FILES}
model.in: model.m4 define.html.in faq.html.in
	m4 model.m4 >model.in
${TUTOR}: global.texi version.texi reference.texi fdl.texi gtags-parser.ref global.ref gtags.ref htags.ref
	@echo "Generating ${MANUAL}.html and ${MANUAL}_toc.html ..."
	@cp global.texi ${MANUAL}.texi
	@texi2html -number ${MANUAL}.texi
	@echo "Generating ${MANUAL}_toc.in ..."
	@echo "@title Tutorial" > ${MANUAL}_toc.in
	@echo "@link Tutorial" >> ${MANUAL}_toc.in
	@echo "@body" >> ${MANUAL}_toc.in
	@echo "This manual is available in <a href=http://www.gnu.org/software/global/manual/>various formats</a>." >> ${MANUAL}_toc.in
	@echo "<hr>" >> ${MANUAL}_toc.in
	@sed -e '1,/^<BODY.*>/d' -e '/<\/BODY.*>/,$$d' < ${MANUAL}_toc.html >> ${MANUAL}_toc.in
	@rm -f ${MANUAL}.texi
clean:
	rm -f ${HTMLS} ${TUTOR} model.in
