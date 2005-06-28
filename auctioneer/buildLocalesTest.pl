#!/usr/bin/perl

open OUT, "> localization.lua";
print OUT << 'EOD';
--[[
	WARNING: This file is automatically generated from those in the
	locales directory. Do not edit it directly.

	This version is NOT deliberatly messed up to facilitate localization troubleshooting.
	However please only edit the original locale.utf8 files, it's cleaner that way.

	$Id$
	Version: <%version%>
]]

EOD

for $file (<locales/????.utf8>) {
	$file =~ /locales.([^.]+).utf8/;
	$locale = $1;
	if ($locale ne "enUS") {
		push(@locales, $locale);
	}
	push(@valid, $locale);
}

print OUT "AUCT_VALID_LOCALES = {[\"".join("\"] = true, [\"", @valid)."\"] = true};\n\n";
print OUT "function Auctioneer_SetLocaleStrings(locale)\n";

print OUT "-- Default locale strings are defined in English\n";
open(DATA, "< locales/enUS.utf8");
while (<DATA>) {
	s/[\r\n]+//g; s/^\s+//; s/\s+$//; s/\-\-.*$//;
	s/([\200-\377])/sprintf("\\%d",ord($1))/eg;
	s/\-\-.*$//;
	if (s/^(\w+)\s*=\s*(.*)/$1=$2/) {
		$defined{$1} = $2;
	}
	print OUT "$_ \n";
}
close DATA;

print OUT "\n";

for $locale (@locales) {
	%localized = ();
	print OUT "-- Locale strings for the $locale locale\n";
	print OUT "if locale == \"$locale\" then\n";
	open(DATA, "< locales/$locale.utf8");
	while (<DATA>) {
		s/[\r\n]+//g; s/^\s+//; s/\s+$//; s/\-\-.*$//;
		s/([\200-\377])/sprintf("\\%d",ord($1))/eg;
		if (s/^(\w+)\s*=\s*(.*)/$1=$2/) {
			if ($2 ne $defined{$1}) {
				$localized{$1} = $2;
				print OUT "$_ \n";
			}
		}
		else {
			print OUT "$_";
		}
	}
	close DATA;
	print OUT "\n";

	$missing = 0;
	for $defined (sort(keys(%defined))) {
		unless ($localized{$defined}) {
			unless ($missing) {
				print OUT "\n-- The following definitions are missing in this locale:\n";
				$missing = 1;
			}
			print OUT"--\t$defined = \"\";\n";
		}
	}
	
	print OUT "end\n\n";
}

print OUT "end\n\nAuctioneer_SetLocaleStrings(GetLocale);\n\n";


