###########################################################
# SIOC
# Base class for the SIOC ontology
###########################################################
#
# $Id$
#

package SIOC;

use strict;
use warnings;

use version; our $VERSION = qv(1.0.0);

use Carp;
use Readonly;
use Template;
use Template::Provider::FromData;
use Data::Dumper qw( Dumper );
use Moose;
use MooseX::AttributeHelpers;

### required attributes

has 'id' => (
    isa => 'Str',
    is => 'rw',
    required => 1,
    );
has 'title' => (
    isa => 'Str',
    is => 'rw',
    required => 1,
    );
has 'url' => (
    isa => 'Str',
    is => 'rw',
    required => 1,
    );
    
### optional attributes

has 'export_url' => (
    isa => 'Str',
    is => 'rw',
    );
has 'description' => (
    isa => 'Str',
    is => 'rw',
    );
has 'comment' => (
    isa => 'Str',
    is => 'rw',
    );
has 'topics' => (
    isa => 'ArrayRef[Str]',
    metaclass => 'Collection::Array',
    is => 'rw',
    provides => {
        'push' => 'add_topics',
    },
    );
has 'feed' => (
    isa => 'Str',
    is => 'rw',
    );
has 'links' => (
    isa => 'ArrayRef[Str]',
    metaclass => 'Collection::Array',
    is => 'rw',
    provides => {
        'push' => 'add_links'
    },
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
has '_template_vars' => (
    isa => 'HashRef',
    metaclass => 'Collection::Hash',
    is => 'rw',
    default => sub { {} },
    provides => {
        'set' => 'set_template_var',
    },
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

sub type {
    my ($self) = @_;
    
    my $type = ref $self;
    $type =~ s/SIOC:://xms;
    $type =~ tr/A-Z/a-z/;
    
    return $type;
}

sub fill_template {
    my ($self) = @_;

    $self->set_template_var(export_url => $self->export_url);
    $self->set_template_var(id => $self->id);
    $self->set_template_var(title => $self->title);
    $self->set_template_var(url => $self->url);
    $self->set_template_var(description => $self->description);
    $self->set_template_var(comment => $self->comment);
    
    return 1;
}

sub export_rdf {
    my ($self) = @_;
    
    my $template = $self->_init_template();
    $self->fill_template();
    my $output;
    my $ok = $template->process('rdfoutput', $self->_template_vars, \$output);
    if (! $ok) {
        croak $template->error();
    }
    $output =~ s/\s+$//xmsg;
    return $output;
}

1;
__DATA__
__rdfoutput__
<sioc:Object>
    <rdfs:comment>Generic SIOC Object named [% title %]</rdfs:comment>
</sioc:Object>
__END__

=head1 NAME

SIOC -- The SIOC Core Ontology

=head1 VERSION

This documentation refers to SIOC version 0.0.1.

=head1 SYNOPSIS

This is an abstract class that isn't meant to be instantiated.

=head1 DESCRIPTION

The SIOC (Semantically-Interlinked Online Communities) Core Ontology provides
the main concepts and properties required to describe information from online
communities (e.g., message boards, wikis, weblogs, etc.) on the Semantic Web.

This distribution implements the various SIOC subclasses like SIOC::Site,
SIOC::User, SIOC::Forum or SIOC::Post. It also contains an exporter class
(SIOC::Exporter) that Perl-based community software can use to generate a
semantic RDF representation of its data.

This class implements an abstract base class for the various SIOC subclasses
like

=over

=item *

SIOC::Site

=item *

SIOC::User

=item *

SIOC::Forum

=back

(See the module's distribution for a complete list of modules.)

The SIOC::Exporter module implements a class that can be used to export
SIOC information as RDF data.

=head1 CLASS ATTRIBUTES

=over

=item id 

An identifier of a SIOC concept instance. For example, a user ID.
Must be unique for instances of each type of SIOC concept within the same
site.

=item name 

The name of a SIOC instance, e.g. a username for a User, group
name for a Usergroup, etc.

=item topic 

A topic of interest, linking to the appropriate URI, e.g., in
the Open Directory Project or of a SKOS category.

=item feed 

A feed (e.g., RSS, Atom, etc.) pertaining to this resource (e.g.,
for a Forum, Site, User, etc.).

=item link 

A URI of a document which contains this SIOC object.

=item links_to 

Links extracted from hyperlinks within a SIOC concept, e.g.,
Post or Site.


=back

=head1 SUBROUTINES/METHODS

=head2 fill_template

Provide template variables from class attributes to Template Toolkit.

=head2 export_rdf

Returns the object's information in RDF format.

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

SIOC depends on the following modules:

=over

=item *

Class::Std

=back

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

Jochen Lillich  (<geewiz@cpan.org>)

=head1 SEE ALSO

SIOC Core Ontology Specification: L<http://rdfs.org/sioc/spec/>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007 Jochen Lillich (<geewiz@cpan.org>).
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.