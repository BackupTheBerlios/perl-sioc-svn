use strict;
use warnings;
use diagnostics;

use Test::More qw/no_plan/;

# load module
BEGIN { use_ok( 'SIOC::User' ); }
require_ok( 'SIOC::User' );

# check methods
can_ok( 'SIOC::User', 'as_string' );

# initialization
{
    my $s = SIOC::User->new({
        id => '1',
        title => 'John Doe',
        url => 'http://www.example.com/sioc/community/1',
        email => 'user@example.com',
    });
    is( ref $s, 'SIOC::User' );
    is( $s->get_id, 1 );
    is( $s->get_title, 'John Doe' );
}
