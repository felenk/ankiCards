#!/usr/bin/perl

use strict;
require "../lib/bgoffice_util_module.pm";



if ($ARGV[0] eq "--help") {
	print <<EOHelp;

Този скрипт сортира думите и премахва повторенията на редовете.
Скрипта не работи с думи, а с редове, за разлика от другите
скриптове, които работят с думи. Т.е. скриптът не се интересува
дали файла е в новия формат с представки или е в стария формат
без представки. Ако форматът на файла е без представки, тогава
ще бъдат премахнати повторенията на думите, защото на един ред
имаме само една дума. В новият формат с представките нещата не
седят така.

Внимавайте много при използването на скрипта, защото това
е единствения скрипт, който пише по файловете с данни. При
това не прави резервно (backup) копие. Скрипта чете данните
до секцията "Думи:" и ги пази в паметта. След това се
прочитат всичките думи и се сортират като се премахват
повторенията. След това се записват данните в същия файл.
Според документацията в секцията думи не може да има
коментари и празни символи. Скрипта не обработва и не
променя заглавната част от файла.

EOHelp

	exit;
}



my $file_name = "";

while ($file_name = next_file($file_name)) {

	print "Sorting $file_name ...\n";

	open(IN, "<$file_name") || die "Cannot open $file_name";
	my @d;
	@d = <IN>;
	close(IN);
	chop(@d);
	my @h = ();
	my @w = ();
	my $r = 0;
	for (@d) {
		if ($r == 0) {
			push(@h, $_);
			$r = (strip_line($_) eq "Думи:");
		} else {
			push(@w, $_);
		}
	}

	@w = sort(@w);

	open(OUT, ">$file_name") || die "Cannot open $file_name";

	for(@h) {
		print OUT "$_\n";
	}

	my $o = "";
	for(@w) {
		if (($_) && ($o ne $_)) {
			print OUT "$_\n";
		}
		$o = $_;
	}

	close(OUT);

}