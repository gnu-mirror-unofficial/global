#
# Copyright (c) 2003 Tama Communications Corporation
#
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
#
SOURCE = ../global.texi
DVI = global.dvi

TARGET= global.html.gz global-html.tar.gz global-info.tar.gz \
	global-texinfo.tar.gz \
	global.dvi.gz global.pdf global.ps.gz

CLEAN_FILES= global.cp global.cps global.fn global.ky \
	global.tp global.vr global.op global.pg \
	global.toc global.aux global.log \
	global.ps global.info*

all: index.html $(TARGET)

update: clean all distclean

index.html: $(TARGET)
	./makehtml.pl index
global.html: $(SOURCE)
	rm -rf tmp; mkdir tmp && cp ../*.texi ../*.ref tmp
	(cd tmp && texi2html -number-sections -monolithic global.texi)
	mv tmp/global.html .
	rm -rf tmp
global.html.gz: global.html
	gzip -c global.html >global.html.gz
global-html.tar.gz: $(SOURCE)
	rm -rf tmp; mkdir tmp && cp ../*.texi ../*.ref tmp
	(cd tmp && texi2html -number-sections -split_chapter global.texi)
	(cd tmp && tar czvf ../global-html.tar.gz global)
	rm -rf tmp
global-info.tar.gz: $(SOURCE)
	makeinfo -I.. $(SOURCE)
	tar czvf global-info.tar.gz global.info*
$(DVI): $(SOURCE)
	rm -rf tmp; mkdir tmp && cp ../*.texi ../*.ref tmp
	(cd tmp && texi2dvi global.texi)
	mv tmp/global.dvi .
	rm -rf tmp
$(DVI).gz: $(DVI)
	gzip -c $(DVI) >$(DVI).gz
global.pdf: $(DVI)
	rm -rf tmp; mkdir tmp && cp ../*.texi ../*.ref tmp
	(cd tmp && texi2pdf global.texi)
	mv tmp/global.pdf .
	rm -rf tmp
global.ps: $(DVI)
	dvips $(DVI) > global.ps
global.ps.gz: global.ps
	gzip -c global.ps > global.ps.gz
global-texinfo.tar.gz:
	cd .. && tar czvf manual/global-texinfo.tar.gz *.texi version.texi *.ref
distclean:
	rm -f $(CLEAN_FILES) $(DVI) global_toc.html
clean:
	rm -f $(CLEAN_FILES) $(DVI) global_toc.html \
		global.html $(TARGET) index.html
	rm -rf tmp
