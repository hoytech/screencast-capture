#!/usr/bin/env perl

use strict;

use Getopt::Long;


# http://wiki.oz9aec.net/index.php/High_quality_screen_capture_with_Ffmpeg
# http://www.zoharbabin.com/how-to-do-noise-reduction-using-ffmpeg-and-sox/


my $resolution = '1920x1080';
my $tempdir;

GetOptions(
    "resolution|r=s" => \$resolution,
    "tempdir|t=s" => \$tempdir,
) || die("Error in command line arguments\n");

my $output = shift || die "usage: $0 [-r 1920x1080] my-screen (it will create my-screen.mkv)\n";



if (!defined $tempdir) {
    require File::Temp;

    $tempdir = File::Temp::tempdir(CLEANUP => 1);
} else {
    die "tempdir $tempdir already exists, i was expecting to mkdir it" if -e $tempdir;
    mkdir($tempdir) || die "couldn't mkdir($tempdir): $!";
}


sys(qq{ffmpeg -f alsa -i pulse -f x11grab -r 25 -s $resolution -i :0.0+0,0 -acodec pcm_s16le -vcodec libx264 -preset ultrafast -threads 0 $tempdir/raw.mkv});

print "DOING NOISE REDUCTION\n";

sys("ffmpeg -i $tempdir/raw.mkv -qscale 0 -an $tempdir/vidstream.mkv");
sys("ffmpeg -i $tempdir/raw.mkv -qscale 0 $tempdir/audstream.wav");

sys("ffmpeg -i $tempdir/raw.mkv -vn -ss 00:00:00 -t 00:00:01 $tempdir/noiseaud.wav");
sys("sox $tempdir/noiseaud.wav -n noiseprof $tempdir/noise.prof");
sys("sox $tempdir/audstream.wav $tempdir/audstream-clean.wav noisered $tempdir/noise.prof 0.21");

sys("ffmpeg -i $tempdir/audstream-clean.wav -i $tempdir/vidstream.mkv -qscale 0 $output.mkv");



sub sys {
  my $cmd = shift;
  print "SYS: $cmd\n";
  system($cmd);
}
