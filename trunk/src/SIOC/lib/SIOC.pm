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
use Carp;

use Class::Std;  # we're using inside-out objects

use Readonly;
use Template;
use Template::Provider::FromData;
use Scalar::Util qw( blessed );

use version; our $VERSION = qv(1.0.0);

{
    # mandatory attributes
    my %id          :ATTR( :name<id> );
    my %title       :ATTR( :name<title> );
    my %url         :ATTR( :name<url> );
    
    # optional attributes
    my %export_url  :ATTR( :name<export_url>, :default('...') );
    my %description :ATTR( :name<description>, :default<undef> );
    my %comment     :ATTR( :name<comment>, :default<undef> );
    my %topics      :ATTR( :name<topic>, :default<[]> );
    my %links       :ATTR( :name<link>, :default<[]> );
    my %feed        :ATTR( :name<feed>, :default<undef> );
    my %links_to    :ATTR( :name<links_to>, :default<undef> );

    # internal attributes
    my %_provider   :ATTR( :name<_provider>, :default<undef> );
    
    sub BUILD {
        my ($self, $obj_ID, $arg_ref) = @_;

        $_provider{$obj_ID} = Template::Provider::FromDATA->new({
            CLASSES => ref $self,
        });
        
        return 1;
    }

    sub _init_template {
        my ($self) = @_;
        
        my $template = Template->new({
            LOAD_TEMPLATES => [ $self->get__provider() ]
        });
        return $template;
    }

    sub _set_template_vars {
        my ($self, $vars) = @_;

        $vars->{export_url}     = $self->get_export_url();
        $vars->{id}             = $self->get_id();
        $vars->{title}          = $self->get_title();
        $vars->{url}            = $self->get_url();
        $vars->{description}    = $self->get_description();
        $vars->{comment}        = $self->get_comment();
        
        return 1;
    }
    
    sub as_string :STRINGIFY {
        my ($self) = @_;
        
        my $template_vars = {};
        $self->_set_template_vars($template_vars);

        my $template = $self->_init_template();
        my $output;
        my $ok = $template->process('rdfoutput', $template_vars, \$output);
        if (! $ok) {
            croak $template->error();
        }
        $output =~ s/\s+$//xmsg;
        return $output;
    }

    sub _assert_family {
        my ($self, $object, $classname) = @_;
        
        if ( (blessed $object)
            && (! $object->isa($classname)) ) {
            croak "FATAL: Argument object is not a $classname!\n";
        }
        
        return 1;
    }

    sub _push_array_attribute {
        my ($self, $attr_hash_ref, $element) = @_;
        
        push @{$attr_hash_ref->{ident $self}}, $element;
    }
}

1;
__DATA__
__rdfoutput__
<sioc:Object>
    <rdfs:comment>Generic SIOC Object named [% title %]</rdfs:comment>
</sioc:Object>
__END__

=head1 NAME

SIOC -- Abstract SIOC base class

=head1 VERSION

This documentation refers to SIOC version 0.0.1.

=head1 SYNOPSIS

This is an abstract class that isn't meant to be instantiated.

=head1 DESCRIPTION

The SIOC (Semantically-Interlinked Online Communities) Core Ontology provides
the main concepts and properties required to describe information from online
communities (e.g., message boards, wikis, weblogs, etc.) on the Semantic Web.

This class implements an abstract base class for the various SIOC subclasses like

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

=head2 BUILD

Base class constructor.

=head2 as_string

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