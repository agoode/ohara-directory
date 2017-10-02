#!/usr/bin/perl -w

use strict;

my $teacher;
my $grade;
print "LAST,FIRST,TEACHER,GRADE,EXTRANAME\n";
for (<>) {
    chomp;
    next unless $_;
    if (/# ([a-zA-Z]+) (\d)/) {
	$teacher = uc($1);
	$grade = $2;
	if ($grade == 0) {
	    $grade = "K";
	}
    } elsif (/(['"a-zA-Z. -]+), (\S+) ?(.*)/) {
	print "$1,$2,$teacher,$grade,$3\n";
    } else {
	die "$_";
    }
}
