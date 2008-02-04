use strict;
use warnings;
use diagnostics;

use Test::More qw/no_plan/;

# load module
BEGIN { use_ok( 'SIOC::Site' ); }
require_ok( 'SIOC::Site' );

# check methods
can_ok( 'SIOC::Site', 'as_string' );

# initialization
{
    my $s = SIOC::Site->new({
        id => 'site1',
        title => 'Test',
        url => 'http://www.example.com/'
    });
    is( ref $s, 'SIOC::Site' );
    is( $s->get_id, 'site1' );
    is( $s->get_title, 'Test' );
    ok(! eval { $s->add_forum(10) });
    ok(! eval { $s->add_forum({ test => 1}) });
    
    use SIOC::Forum;
    my $forum = SIOC::Forum->new({
        id => 'forum1',
        title => 'Test forum',
        url => 'http://www.example.com/forum/test'
    });
    ok(eval { $s->add_forum($forum) });
}
