use strict;
use warnings;
use diagnostics;

use Test::More qw/no_plan/;

# load module
BEGIN { use_ok( 'SIOC::Usergroup' ); }

# make tests easier
my $PACKAGE = 'SIOC::Usergroup';

# load package
require_ok( $PACKAGE );

# check existance of documented methods
foreach my $subroutine qw( new ) {
        
    can_ok($PACKAGE, $subroutine);

}
