#!/usr/bin/perl -w

use strict;
use File::Copy;

my $x = 1000;

while(<>) {
    chomp;
    my @line = split / /, $_;
    my ($old, $new);
    if (@line == 1) {
        # unnumbered form, give it a number
        $new = "$x.jpg";
        $x++;
        $old = $line[0];
    } else {
        $new = "$line[0].jpg";
        $old = $line[1];
    }

    my $old_path = "../returned-forms/$old";
    my $new_path = "../numbered-forms/$new";
    die unless -e $old_path;
    die if -e $new_path;
    print "$old_path -> $new_path\n";
    move($old_path, $new_path) or die "Move failed: $!";
}
