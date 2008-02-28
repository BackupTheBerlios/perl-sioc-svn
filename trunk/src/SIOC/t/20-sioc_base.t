use strict;
use warnings;
use diagnostics;

use Test::More qw/no_plan/;

# load module
BEGIN { use_ok( 'SIOC' ); }
require_ok( 'SIOC' );

# check methods
can_ok( 'SIOC', 'export_rdf' );

# initialization
{
    my $s = SIOC->new({
        id => '1',
        name => 'Test',
        url => 'http://www.example.com/sioc/base/1'
    });
    is( ref $s, 'SIOC' );
    is( $s->id, 1 );
    is( $s->name, 'Test' );
}

