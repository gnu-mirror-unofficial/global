#! /usr/bin/env perl
#
# Copyright (c) 2003 Tama Communications Corporation
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
# usage: makehtml.pl skelton-file ...
#
# skelton-file:
# +-------------------------------
# |...
# |@DATE@				=> last updated November 2, 2003
# |...
# |(@FILESIZE(global.tar.gz) bytes)	=> 30k bytes
# |...
@month = qw(
        January
        February
        March
        April
        May
        June
        July
        August
        September
        October
        November
        December
);
sub getdate {
	my($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time());
	$year += 1900;
	my($date) = "$month[$mon] $mday, $year";
	$date;
}
sub getsize {
	my($file) = @_;
	my(@st);

	if (! -f $file) {
		die("File $file not found.\n");
	}
	if (!(@st = stat($file))) {
		die("Cannot get file size.\n");
	}
	$st[7];
}
for $file (@ARGV) {
	if (! -f "$file.in") {
		die("File $file.in not found.\n");
	}
	open(IN, "$file.in") || die("Cannot open file '$file.in'.\n");
	open(OUT, ">$file.html") || die("Cannot open file '$file.html'.\n");
	while(<IN>) {
		if (/\@DATE\@/) {
			my($date) = getdate();
			s/\@DATE\@/$date/;
		}
		if (/\@FILESIZE\(([^)]+)\)/) {
			my($size) = getsize($1);
			$size = int($size / 1000);
			s/\@FILESIZE\([^)]+\)/${size}k/;
		}
		print OUT;
	}
	close(OUT);
	close(IN);
}
