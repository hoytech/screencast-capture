# screencast-capture
Script to capture screencast with ffmpeg

This is a simple perl script that runs ffmpeg with the x11grab format, useful for making screencasts.

## Usage

Here is the simple usage:

    $ ./screencast-capture.pl into
    ... press "q" when done ...

    creates intro.mkv

## Notes

* By default it puts intermediate files into a directory in /tmp/ (or whatever File::Temp decides), however you can pass in a directory with the `--tempdir` switch. It will `mkdir()` this directory (it must not exist beforehand) and will not clean it up afterwards, in case you wish to access the intermediate files for whatever reason.

* The default resolution is `1920x1080` but this can be changed with the `--resolution` switch. The frame rate is 25 fps (currently hard-coded).

* It uses the ffmpeg preset `ultrafast` to minimize the CPU required while filming the screencast. After the filming stops, it re-encodes this with higher compression.

* The first second of your recording should be silent. This is because this second is used to build a noise profile and apply noise reduction with sox.

## Examples

The [vmprobe screencasts](https://vmprobe.com/screencasts) were recorded with this tool.
