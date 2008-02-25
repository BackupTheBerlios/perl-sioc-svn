###########################################################
# SIOC::Exporter
# Exporter class for the SIOC ontology
###########################################################
#
# $Id$
#

package SIOC::Exporter;

use strict;
use warnings;

use version; our $VERSION = qv(1.0.0);

use Moose;
use MooseX::AttributeHelpers;
use Data::Dumper qw( Dumper );
use Carp;

### required attributes

has 'host' => (
    isa => 'Str',
    is => 'rw',
    required => 1,
);

### optional attributes

has 'encoding' => (
    isa => 'Str',
    is => 'ro',
    default => sub { 'utf-8' },
);
has 'generator' => (
    isa => 'Str',
    is => 'ro',
    default => sub { 'perl-SIOC' },
);
has 'export_email' => (
    isa => 'Str',
    is => 'ro',
    default => sub { 0 },
);
    
### internal attributes

has '_provider' => (
    is => 'ro', 
    isa => 'Template::Provider::FromDATA',
    default => sub {
        my ($self) = @_; 
        Template::Provider::FromDATA->new({
            CLASSES => ref $self,
        });
    },
);
has '_object' => (
    isa => 'SIOC',
    is => 'rw',
);
has '_url' => (
    isa => 'Str',
    is => 'ro',
    default => sub { 'http://wiki.sioc.org/...' },
);
has '_version' => (
    isa => 'Str',
    is => 'ro',
    default => sub { "$VERSION" },    
);

### methods

sub _init_template {
    my ($self) = @_;

    # create new Template object
    my $template = Template->new({
        LOAD_TEMPLATES => [ $self->_provider ]
    });

    return $template;
}

sub register_object {
    my ($self, $object) = @_;
    
    my $export_url = $self->object_export_url($object);
    $object->export_url($export_url);
    
    return $export_url;
}

sub export_object {
    my ($self, $object) = @_;
    
    $self->_object($object);
};

sub object_export_url {
    my ($self, $object) = @_;
    
    my $url = sprintf("%s/sioc.pl?class=%s&id=%s", 
        $self->host,
        $object->type, 
        $object->id
    );

    return $url;
}

sub output {
    my ($self) = @_;

    # prepare template engine
    my $template = $self->_init_template();
    my $output;

    my $object_rdf = '';

    # set object url attribute
    $self->_object->export_url($self->object_export_url($self->_object));

    # fill template variables
    my $template_vars = {
        encoding => $self->encoding,
        exporter_url => $self->_url,
        exporter_version => $VERSION,
        exporter_generator => 'perl-SIOC',
        object => $self->_object,
    };

    # process template
    my $ok = $template->process('rdfoutput', $template_vars, \$output);
    if (! $ok) {
        croak $template->error();
    }

    return $output;
}

1;
__DATA__
__rdfoutput__
Content-Type: application/rdf+xml; charset=[% encoding %]

<?xml version="1.0" encoding="[% encoding %]" ?>
<rdf:RDF
    xmlns="http://xmlns.com/foaf/0.1/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:admin="http://webns.net/mvcb/"
    xmlns:content="http://purl.org/rss/1.0/modules/content/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:sioc="http://rdfs.org/sioc/ns#">

<foaf:Document rdf:about="">
	<dc:title>SIOC profile for [% object.title %]</dc:title>
	<dc:description>A SIOC profile describes the structure and contents of a community site (e.g., weblog) in a machine processable form. For more information refer to the <a href="http://rdfs.org/sioc">SIOC project page</a>'></dc:description>
	<foaf:primaryTopic rdf:resource="[% object.url | url %]"/>
	<admin:generatorAgent rdf:resource="[% exporter_url | url %]?version=[% exporter_version | uri %]"/>
	<admin:generatorAgent rdf:resource="[% exporter_generator %]"/>
</foaf:Document>

[% IF rdf_content %][% rdf_content %][% END %]

[% IF object %]
<!-- type: [% object.type %], id: [% object.id %] -->
[% object.export_rdf %]
[% END %]

</rdf:RDF>
__END__

=head1 NAME

SIOC::Exporter -- SIOC RDF exporter class

=head1 VERSION

The initial template usually just has:

This documentation refers to <Module::Name> version 0.0.1.

=head1 SYNOPSIS

   use SIOC::Exporter;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.

=head1 DESCRIPTION

A full description of the module and its features.

May include numerous subsections (i.e., =head2, =head3, etc.).

=head1 SUBROUTINES/METHODS

A separate section listing the public components of the module's interface.

These normally consist of either subroutines that may be exported, or methods
that may be called on objects belonging to the classes that the module
provides.

Name the section accordingly.

In an object-oriented module, this section should begin with a sentence (of the
form "An object of this class represents ...") to give the reader a high-level
context to help them understand the methods that are subsequently described.

=head1 DIAGNOSTICS

A list of every error and warning message that the module can generate (even
the ones that will "never happen"), with a full explanation of each problem,
one or more likely causes, and any suggested remedies.

=head1 CONFIGURATION AND ENVIRONMENT

A full explanation of any configuration system(s) used by the module, including
the names and locations of any configuration files, and the meaning of any
environment variables or properties that can be set. These descriptions must
also include details of any configuration language used.

=head1 DEPENDENCIES

A list of all of the other modules that this module relies upon, including any
restrictions on versions, and an indication of whether these required modules
are part of the standard Perl distribution, part of the module's distribution,
or must be installed separately.

=head1 INCOMPATIBILITIES

A list of any modules that this module cannot be used in conjunction with.
This may be due to name conflicts in the interface, or competition for system
or program resources, or due to internal limitations of Perl (for example, many
modules that use source code filters are mutually incompatible).

=head1 BUGS AND LIMITATIONS

A list of known problems with the module, together with some indication of
whether they are likely to be fixed in an upcoming release.

Also, a list of restrictions on the features the module does provide: data types
that cannot be handled, performance issues and the circumstances in which they
may arise, practical limitations on the size of data sets, special cases that
are not (yet) handled, etc.

The initial template usually just has:

There are no known bugs in this module.

Please report problems to <Maintainer name(s)> (<contact address>)

Patches are welcome.

=head1 AUTHOR

<Author name(s)>  (<contact address>)

=head1 LICENSE AND COPYRIGHT

Copyright (c) <year> <copyright holder> (<contact address>).
All rights reserved.

followed by whatever license you wish to release it under.

For Perl code that is often just:

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.