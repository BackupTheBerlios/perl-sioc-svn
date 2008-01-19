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
use Readonly;

our $VERSION = do { if (q$Revision$ =~ /Revision: (?:\d+)/mx) { sprintf "1.0-%03d", $1; }; };

use Class::Std;
{

    my %id :ATTR;
    my %name :ATTR;
    my %topic :ATTR;
    my %feed :ATTR;
    my %link :ATTR;
    my %links_to :ATTR;

    Readonly my $ABSTRACT_CLASS => "This is an abstract class. Please use a subclass!\n";
    
    sub as_string :STRINGIFY {
        croak $ABSTRACT_CLASS;
    }

}

1;
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

=head2 as_string

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