#!/usr/bin/perl

use strict;
use warnings;

our $VERSION = q(1.0.0);

use Readonly;
use Carp;
use DBI;

use SIOC;
use SIOC::User;
use SIOC::Site;
use SIOC::Forum;
use SIOC::Post;
use SIOC::Exporter;

# constants

Readonly my $DBNAME => 'sioctest';
Readonly my $DBUSER => 'sioctest';
Readonly my $DBPW => 'sioctest';
Readonly my $DSN => "DBI:mysql:database=$DBNAME";

# create exporter

my $exporter = SIOC::Exporter->new({
    host => 'http://www.example.com',
});

# connect to database

my $dbh = DBI->connect($DSN, $DBUSER, $DBPW) or croak $dbh->errstr;

# export users

my $sth = $dbh->prepare("SELECT id, name FROM users");
$sth->execute();

while (my $ref = $sth->fetchrow_hashref()) {
    my $user = SIOC::User->new({
        id => $ref->{id},
        name => $ref->{name},
        url => 'http://www.perl-programmieren.de',
        title => 'Jochen Lillich',
        email => 'webmaster@perl-programmieren.de',
        foaf_uri => 'http://www.foaf.com/Dummy URI'
    });
    $exporter->export_object($user1);
    print $exporter->output(), "\n\n";
}

$sth->finish();

# disconnect from database

$dbh->disconnect();
