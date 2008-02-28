#!/usr/bin/perl

use strict;
use warnings;

our $VERSION = q(1.0.0);

use SIOC;
use SIOC::User;
use SIOC::Site;
use SIOC::Forum;
use SIOC::Post;
use SIOC::Exporter;

# create exporter

my $exporter = SIOC::Exporter->new({
    host => 'http://www.example.com',
});

# SIOC::User

print "SIOC::User:\n\n";
my $user1 = SIOC::User->new({
    id => 1,
    name => 'Jochen Lillich',
    url => 'http://www.perl-programmieren.de',
    title => 'Jochen Lillich',
    email => 'webmaster@perl-programmieren.de',
    foaf_uri => 'http://www.foaf.com/Dummy URI'
});

# output user

$exporter->export_object($user1);
print $exporter->output(), "\n\n";

# SIOC::Site

my $site = SIOC::Site->new({
    id => 1,
    name => 'My Site',
    url => 'http://www.example.com',
});
$exporter->register_object($user1);

# add user to site
$site->add_administrator($user1);

# SIOC::Forum

my $forum = SIOC::Forum->new({
    id => 1,
    host => $site,
    name => 'My First Forum',
    url => 'http://www.example.com/forum/First',
});
$exporter->register_object($forum);

# add forum to site
$site->add_forum($forum);

# SIOC::Post

my $post = SIOC::Post->new({
    id => 3,
    url => $forum->url . '/3',
    name => 'Testpost',
    creator => $user1,
    created => '2008-02-25 22:04',
    encoded_content => 'Foo',
    content => 'Foo',
});
$exporter->register_object($post);

# dump post
print "Post:\n", $post->export_rdf(), "\n\n";

# add post to forum
$forum->add_item($post);

# dump forum
print "Forum:\n", $forum->export_rdf(), "\n\n";

# export site
print "SIOC::Site:\n\n";

$exporter->export_object($site);
print $exporter->output(), "\n\n";
