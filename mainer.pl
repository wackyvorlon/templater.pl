#! /usr/local/bin/perl -w
eval 'exec /usr/local/bin/perl -S $0 ${1+"$@"}'
  if 0;    #$running_under_some_shell

use strict;
use File::Find ();
use File::Basename;


# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats.

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name  = *File::Find::name;
*dir   = *File::Find::dir;
*prune = *File::Find::prune;

sub wanted;
sub stuff;


# Traverse desired filesystems
File::Find::find( { wanted => \&wanted }, '/home/drakej/socr/markdown/' );

system("/home/drakej/socr/bin/finder2.pl");


exit;

sub wanted {
    my ( $dev, $ino, $mode, $nlink, $uid, $gid );

    /^.*\.md\z/s
      && ( ( $dev, $ino, $mode, $nlink, $uid, $gid ) = lstat($_) )
          && stuff($name);
    
}

sub stuff {
    my $name=shift;
    my $fname = basename($name);
    system("/home/drakej/socr/bin/templater.pl $fname");
    
}
