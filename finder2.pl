#! /usr/local/bin/perl -w
eval 'exec /usr/local/bin/perl -S $0 ${1+"$@"}'
  if 0;    #$running_under_some_shell

#use strict;
use File::Copy qw(copy);
use YAML::Tiny;
use File::Basename;
use File::Path;

use File::Find ();

# Set the variable $File::Find::dont_use_nlink if you're using AFS,
# since AFS cheats.

# for the convenience of &wanted calls, including -eval statements:
use vars qw/*name *dir *prune/;
*name  = *File::Find::name;
*dir   = *File::Find::dir;
*prune = *File::Find::prune;

sub wanted;
sub stuff;

# Load config variables.
$yaml    = YAML::Tiny->read('/home/drakej/socr/config');
$outpath = $yaml->[0]->{outputpath};
$inpath  = $yaml->[0]->{inputpath};
$asspath = $yaml->[0]->{template_assets};

# Traverse desired filesystems
File::Find::find( { wanted => \&wanted }, ( $inpath, $asspath ) );
exit;

sub wanted {
    my ( $dev, $ino, $mode, $nlink, $uid, $gid );

    ( ( $dev, $ino, $mode, $nlink, $uid, $gid ) = lstat($_) )
      && !/^.*\.tpl\z/s
      && !/^.*\.md\z/s
      && !/^.*~\z/s
      && -f _
      && stuff($name);

}

sub stuff {
    my $name = shift;
    print "Copying $name ";
    $oname=$name;
    
    $oname=~s/$inpath/$outpath/;
    $oname=~s/$asspath/$outpath/;
    print "to $oname...\n";
    my $dir = dirname($oname);
    if ( ! -d $dir) {
        mkpath($dir);
        
    }
    
    copy( $name, $oname ) or die $!;

}
