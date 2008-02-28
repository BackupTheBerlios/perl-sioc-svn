use strict;
use warnings;
use diagnostics;

use Test::More qw/no_plan/;

# load module
BEGIN { use_ok( 'SIOC::User' ); }
require_ok( 'SIOC::User' );

# check methods
can_ok( 'SIOC::User', 'export_rdf' );

# initialization
{
    my $s = SIOC::User->new({
        id => '1',
        name => 'John Doe',
        url => 'http://www.example.com/sioc/community/1',
        foaf_uri => 'foaf',
        email => 'user@example.com',
    });
    is( ref $s, 'SIOC::User' );
    is( $s->id, 1 );
    is( $s->name, 'John Doe' );
}
