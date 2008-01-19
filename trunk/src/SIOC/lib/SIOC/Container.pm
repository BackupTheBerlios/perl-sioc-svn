###########################################################
# SIOC::Container
# Container class for the SIOC ontology
###########################################################
#
# $Id$
#

package SIOC::Container;
use base qw( SIOC );

use strict;
use warnings;

our $VERSION = do { if (q$Revision$ =~ /Revision: (?:\d+)/mx) { sprintf "1.0-%03d", $1; }; };

{
    my %sioc_container_of :ATTR;
    my %sioc_has_owner :ATTR;
    my %sioc_has_parent :ATTR;
    my %sioc_has_subscriber :ATTR;
    my %sioc_parent_of :ATTR;
}
1;
__END__
    
=head1 NAME

SIOC::Container -- SIOC Container class

=head1 VERSION

This documentation refers to SIOC::Container version 0.0.1.

=head1 SYNOPSIS

   use SIOC::Container;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.

=head1 DESCRIPTION

Container is a high-level concept used to group content Items together. The
relationships between a Container and the Items that belong to it are
described using sioc:container_of and sioc:has_container properties. A
hierarchy of Containers can be defined in terms of parents and children using
sioc:has_parent and sioc:parent_of.

Subclasses of Container can be used to further specify typed groupings of
Items in online communities. Forum, a subclass of Container and one of the
core classes in SIOC, is used to describe an area on a community Site (e.g., a
forum or weblog) on which Posts are made. The SIOC Types Ontology Module
contains additional, more specific subclasses of SIOC::Container.

=head1 CLASS ATTRIBUTES

=over

=item container_of 

An Item that this Container contains.

=item has_owner 

A User that this Container is owned by.

=item has_parent 

A Container or Forum that this Container or Forum is a
child of.

=item has_subscriber 

A User who is subscribed to this Container.

=item parent_of 

A child Container or Forum that this Container or Forum is a
parent of.

=back

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
