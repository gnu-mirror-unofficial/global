MANUAL=	globaldoc
FILES=	global.in whatsnew.in ${MANUAL}_toc.in license.in links.in \
	plans.in contribute.in museum.in maillist.in download.in
HTMLS=	global.html whatsnew.html ${MANUAL}_toc.html license.html links.html \
	plans.html contribute.html museum.html maillist.html download.html

TUTOR=	${MANUAL}_toc.in ${MANUAL}.html
IMAGE=	globe.jpg sglobe.jpg

all: ${HTMLS} ${MANUAL}.html

${HTMLS}: ${FILES} ${TUTOR}
	@./makehtml.pl -v ${FILES}

${TUTOR}: ${MANUAL}.texi
	@echo "Generating ${MANUAL}.html and ${MANUAL}_toc.html ..."
	@texi2html -number ${MANUAL}.texi
	@echo "Generating ${MANUAL}_toc.in ..."
	@echo "@title Tutorial" > ${MANUAL}_toc.in
	@echo "@link Tutorial" >> ${MANUAL}_toc.in
	@echo "@body" >> ${MANUAL}_toc.in
	@sed -e '1,/^<BODY.*>/d' -e '/<\/BODY.*>/,$$d' < ${MANUAL}_toc.html >> ${MANUAL}_toc.in
clean:
	rm -f ${HTMLS} ${TUTOR}
