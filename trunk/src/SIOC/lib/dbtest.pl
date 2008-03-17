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

