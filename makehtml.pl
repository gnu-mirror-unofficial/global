#!/usr/bin/perl
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
# usage: makehtml.pl [-v] skelton-file ...
#
# skelton-file:
# +-------------------------------
# |@title <title for html>
# |@link <link name for anchor>
# |@license
# |<license for this file>
# |@body
# |...
############################################################
# Definitions
############################################################
#
# String
#
$l_year = '2000,2001';
$l_company = 'Tama Communications Corporation';
$l_name = 'Shigio Yamaguchi';
$l_copyright = 'Copyright';
$l_reserved = 'All rights reserved.';
$l_statement = "$l_copyright $l_year $l_company. $l_reserved";
$l_biglogo = 'globe.jpg';
$l_smalllogo = 'sglobe.jpg';
$l_GFDL = 'Permission is granted to copy, distribute and/or modify this document
under the terms of the GNU Free Documentation License, Version 1.1';
#
# Color
#
$c_bgcolor	= '#ffffff';
$c_text		= '#000000';
$c_link		= '#1f00ff';
$c_alink	= '#ff0000';
$c_vlink	= '#9900dd';
$c_menucolor	= '#dcdcdc';
$c_titlecolor	= '#660000';
# Size
$w_menuwidth	= '100';
$hr		= "<hr width=100% size=3 align=left noshade>\n";
#
# Parts
#
sub start_html {
	"<!doctype html public \"-//W3C//DTD HTML 3.2 Final//EN\">\n" .
	"<html>\n" .
	"<head>\n" .
	"<title>$_[0]</title>\n" .
	"<meta name='keywords' content='gtags,htags,gtags-mode'>\n" .
	"<meta name='description' content='GNU GLOBAL is a source code tag system that works the same way across diverse environments.'>\n" .
	"</head>\n" .
	"<body bgcolor=$c_bgcolor text=$c_text link=$c_link alink=$c_alink vlink=$c_vlink>\n";
}
sub end_html {
	"</body></html>\n";
}
sub logobox {
	my($title, $fontsize, $logo) = @_;
	"<table width='100%' cellpadding=5 cellspacing=0 border=0>\n" .
	"<tr>\n" .
		"<td bgcolor=black align=left valign=middle>\n" .
			"<font color=white size=$fontsize>$title</font>\n" .
		"</td>\n" .
		"<td bgcolor=black>\n" .
			"<img src=$logo alt='GLOBE' align=right hspace=15>\n" .
		"</td>\n" .
	"</tr>\n" .
	"</table>\n";
}
sub title {
	"<h2><font color=$c_titlecolor>$_[0]</font></h2>\n";
}
sub home_title {
	logobox("<h2>$_[0]</h2>", 7, $l_biglogo) .
	"<p align=right><i><font size=-1>\n" .
	"$l_copyright $l_year $l_company. $l_reserved" .
	"</font></i></p>\n";
}
sub copyright {
	my($msg) = $l_statement;
	$msg .= '<br>';
	$msg .= $l_GFDL;
	return logobox($msg, -1, $l_smalllogo);
}
# End of definitions
############################################################
while ($ARGV[0] =~ /^-/) {
	$opt = shift;
	if ($opt eq '-v') {
		$verbose = 1;
	}
}
$total = @ARGV;
#
# Making %outfile, %title, %link, %body for each @ARGV.
#
for ($i = 0; $i < $total; $i++) {
	my($infile, $outfile, $skip);

	$infile = $outfile = $ARGV[$i];
	$outfile =~ s/\.[^.]+/.html/;
	$outfile{$infile} = $outfile;
	open(INFILE, "$infile") || die("cannot open '$infile'\n");
	$license = 0;
	while (<INFILE>) {
		if ($license) {
			if (/^\@/) {
				$license = 0;
			} else {
				next;
			}
		}
		if (/^\@body/) {
			last;
		} elsif (/^\@title (.*)$/) {
			$title{$infile} = $1;
		} elsif (/^\@link (.*)$/) {
			$link{$infile} = $1;
		} elsif (/^\@license/) {
			$license = 1;
		} else {
			die("illegal skelton file format.($infile)\n");
		}
	}
	if (!defined($title{$infile})) {
		die("\@title not found.\n");
	}
	if (!defined($link{$infile})) {
		die("\@link not found.\n");
	}
	my(@body) = <INFILE>;
	$body{$infile} = \@body;
	close(INFILE);
}
#
# Generating html files.
#
for ($i = 0; $i < $total; $i++) {
	my($infile) = $ARGV[$i];

	print STDERR "Generating $outfile{$infile} ...\n" if ($verbose);
	open(OUTFILE, ">$outfile{$infile}") || die("cannot open '$outfile{$infile}'\n");

	# (1) Print prologue.
	print OUTFILE start_html($title{$infile});
	print OUTFILE "<small>\n";
	print OUTFILE "<a href=http://www.gnu.org/>GNU Project</a> -\n";
	print OUTFILE "<a href=http://www.gnu.org/software/>Software</a>\n";
	print OUTFILE "</small>\n";
	print OUTFILE "<table width='100%' cellpadding=10 cellspacing=0 border=0>";
	print OUTFILE "<tr>\n";

	# (2) Print menu.
	print OUTFILE "<td valign=top align=center bgcolor=$c_menucolor width=$w_menuwidth>\n";
	print OUTFILE "<b>\n";
	foreach $f (@ARGV) {
		print OUTFILE "<p>";
		print OUTFILE "<a href=$outfile{$f}>" if ($f ne $infile);
		print OUTFILE $link{$f};
		print OUTFILE "</a>" if ($f ne $infile);
		print OUTFILE "\n";
	}
	print OUTFILE "</b>\n";
	print OUTFILE "</td>\n";

	# (3) Print body.
	print OUTFILE "<td valign=top>\n";
	if ($infile eq 'global.in') {
		print OUTFILE home_title($title{$infile});
	} else {
		print OUTFILE title($title{$infile});
	}
	print OUTFILE $hr;
	print OUTFILE @{$body{$infile}};
	print OUTFILE "</td>\n";
	print OUTFILE "</tr>\n";
	print OUTFILE "<tr>\n";
	print OUTFILE "<td valign=center align=center bgcolor=$c_menucolor width=$w_menuwidth>\n";
	print OUTFILE "<a href=#top>[Top of page]</a>\n";
	print OUTFILE "</td>\n";
	print OUTFILE "<td>\n";
	print OUTFILE $hr;
	print OUTFILE copyright();
	print OUTFILE "</td>\n";
	

	# (4) Print epilogue.
	print OUTFILE "</td>\n";
	print OUTFILE "</tr>\n";
	print OUTFILE "</table>\n";
	print OUTFILE end_html;

	close(OUTFILE);
}
