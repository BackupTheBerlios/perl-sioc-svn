use strict;
use warnings;
use diagnostics;

use Test::More qw/no_plan/;

# load module
BEGIN { use_ok( 'SIOC::Community' ); }
require_ok( 'SIOC::Community' );

# check methods
can_ok( 'SIOC::Community', 'as_string' );

# initialization
{
    my $s = SIOC::Community->new({
        id => '1',
        title => 'Test',
        url => 'http://www.example.com/sioc/community/1'
    });
    is( ref $s, 'SIOC::Community' );
    is( $s->get_id, 1 );
    is( $s->get_title, 'Test' );
}
