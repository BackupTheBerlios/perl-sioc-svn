#!perl -T

use strict;
use warnings;
use Test::More tests => 15;

sub not_in_file_ok {
    my ($filename, %regex) = @_;
    open my $fh, "<", $filename
        or die "couldn't open $filename for reading: $!";

    my %violated;

    while (my $line = <$fh>) {
        while (my ($desc, $regex) = each %regex) {
            if ($line =~ $regex) {
                push @{$violated{$desc}||=[]}, $.;
            }
        }
    }

    if (%violated) {
        fail("$filename contains boilerplate text");
        diag "$_ appears on lines @{$violated{$_}}" for keys %violated;
    } else {
        pass("$filename contains no boilerplate text");
    }
}

not_in_file_ok(README =>
    "The README is used..."       => qr/The README is used/,
    "'version information here'"  => qr/to provide version information/,
);

not_in_file_ok(Changes =>
    "placeholder date/time"       => qr(Date/time)
);

sub module_boilerplate_ok {
    my ($module) = @_;
    not_in_file_ok($module =>
        'the great new $MODULENAME'   => qr/ - The great new /,
        'boilerplate description'     => qr/Quick summary of what the module/,
        'stub function definition'    => qr/function[12]/,
    );
}

module_boilerplate_ok('lib/SIOC.pm');
module_boilerplate_ok('lib/SIOC/Community.pm');
module_boilerplate_ok('lib/SIOC/Container.pm');
module_boilerplate_ok('lib/SIOC/Exporter.pm');
module_boilerplate_ok('lib/SIOC/Forum.pm');    
module_boilerplate_ok('lib/SIOC/Item.pm');     
module_boilerplate_ok('lib/SIOC/Post.pm');     
module_boilerplate_ok('lib/SIOC/Role.pm');     
module_boilerplate_ok('lib/SIOC/Site.pm');     
module_boilerplate_ok('lib/SIOC/Space.pm');    
module_boilerplate_ok('lib/SIOC/Thread.pm');   
module_boilerplate_ok('lib/SIOC/User.pm');     
module_boilerplate_ok('lib/SIOC/Usergroup.pm');