#!/usr/bin/perl -w
# templater.pl --- A program to do templating for SOCR
# Author: Paul Anderson <wackyvorlon@paul-andersons-macbook-pro-3.local>
# Created: 19 Jul 2012
# Version: 0.01

#use warnings;
#use strict;
use diagnostics;
use File::Slurp;
use Text::MultiMarkdown qw(markdown);
use YAML::Tiny;
use Data::Dumper;
use autodie;


sub frobulate {
  my $fn=shift;
  $frob=read_file($fn);
  $frobbed = markdown($frob);
  return $frobbed;
  
}


die "Nothing on command line!\n" unless @ARGV;    # Need some filenames.

# Grab name of template from config file.
$yaml = YAML::Tiny->read('../config');
$tpl  = $yaml->[0]->{template};

$outpath=$yaml->[0]->{outputpath};


# Read in contents of the template.
$tplcontents = read_file($tpl) or die $!;

# Read in file on command line.
$input = read_file( $ARGV[0] ) or die $!;

# Do magic!

for ($tplcontents) {
    s/include (.*)/frobulate($1) /ge;
}

$name = $ARGV[0];
$name =~ s/.md//;

for ($tplcontents) {
    s/documentid/$name/ge;
}




# Process markdown.
$html = markdown($input);

# Insert HTML into template.
$tplcontents =~ s/HERE/$html/;


#Dump to disk.
$fname = $ARGV[0];
$fname =~ s/\.md//;
$fname = $fname . ".html";

print STDERR "Output filename: $fname\n";

write_file($outpath.$fname, $tplcontents) or die $!;

__END__

=head1 NAME

templater.pl - Processes markdown templates for SOCR.

=head1 SYNOPSIS

templater.pl file


=head1 DESCRIPTION

Takes a template and processes it. include directive causes loading of named file. Markdown filename is placed on command line.

=head1 AUTHOR

Paul Anderson, E<lt>ander1x@uwindsor.caE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Paul Anderson

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.2 or,
at your option, any later version of Perl 5 you may have available.

=head1 BUGS

None reported... yet.

=cut
