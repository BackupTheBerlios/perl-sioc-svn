###########################################################
# SIOC::Item
# Item class for the SIOC ontology
###########################################################
#
# $Id$
#

package SIOC::Item;

use strict;
use warnings;

use version; our $VERSION = qv(1.0.0);

use Moose;
use MooseX::AttributeHelpers;

extends 'SIOC';

### required attributes

has 'created' => (
    isa => 'Str',
    is => 'rw',
    );
has 'creator' => (
    isa => 'SIOC::User',
    is => 'rw',
    );

### optional attributes

has 'modified' => (
    isa => 'Str',
    is => 'rw'
    );
has 'modifier' => (
    isa => 'SIOC::User',
    is => 'rw',
    );
has 'view_count' => (
    isa => 'Num',
    is => 'rw',
    );
has 'about' => (
    isa => 'Str',
    is => 'rw',
    );
has 'container' => (
    isa => 'SIOC::Container',
    is => 'rw',
    );
has 'parent_posts' => (
    isa => 'ArrayRef[SIOC::Item]',
    metaclass => 'Collection::Array',
    is => 'rw',
    default => sub { [] },
    provides => {
        'push' => 'add_parent_posts',
    },
    );
has 'ip_address' => (
    isa => 'Str',
    is => 'rw',
    );
has 'previous_by_date' => (
    isa => 'SIOC::Item',
    is => 'rw',
    );
has 'next_by_date' => (
    isa => 'SIOC::Item',
    is => 'rw',
    );
has 'previous_version' => (
    isa => 'SIOC::Item',
    is => 'rw',
    );
has 'next_version' => (
    isa => 'SIOC::Item',
    is => 'rw',
    );

### methods

after 'fill_template' => sub {
    my ($self) = @_;
    
    $self->set_template_var(created => $self->created);
    $self->set_template_var(creator => $self->creator);
};

1;
__END__
    
=head1 NAME

SIOC::Item -- SIOC Item class

=head1 VERSION

The initial template usually just has:

This documentation refers to SIOC::Item version 0.0.1.

=head1 SYNOPSIS

   use <Module::Name>;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.

=head1 DESCRIPTION

SIOC::Item is a high-level concept for content items. It has subclasses that
further specify different types of Items. One of these subclasses (which plays
an important role in SIOC) is SIOC::Post, used to describe articles or messages
created within online community Sites. The SIOC Types Ontology Module
describes additional, more specific subclasses of sioc:Item.

Items can be contained within Containers.

=head1 CLASS ATTRIBUTES

=over

=item about 

Specifies that this Item is about a particular resource, e.g., a
Post describing a book, hotel, etc.

=item has_container 

The Container to which this Item belongs.

=item has_creator 

This is the User who made this Item.

=item has_modifier 

A User who modified this Item.

=item has_reply 

Points to an Item or Post that is a reply or response to
this Item or Post.

=item ip_address 

The IP address used when creating this Item. This can be
associated with a creator. Some wiki articles list the IP addresses for the
creator or modifiers when the usernames are absent.

=item next_by_date 

Next Item or Post in a given Container sorted by date.

=item next_version 

Links to the next revision of this Item or Post.

=item num_views 

The number of times this Item, Thread, User profile, etc.
has been viewed.

=item previous_by_date 

Previous Item or Post in a given Container sorted by
date.

=item previous_version 

Links to a previous revision of this Item or Post.

=item reply_of 

Links to an Item or Post which this Item or Post is a reply
to.

=item dc:subject 

Can be used for keywords describing the subject of an Item
or Post. See also: sioc:topic.

=item dc:title 

Specifies the title of a resource. Usually used to describe
the title of an Item or Post.

=item dcterms:created 

Details the date and time when a resource was created.
Usually used as a property of an Item or Post.

=item dcterms:modified 

Details the date and time when a resource was
modified. Usually used as a property of an Item or Post.

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

For diagnostics information, see the SIOC base class.

=head1 CONFIGURATION AND ENVIRONMENT

This module doesn't need configuration.

=head1 DEPENDENCIES

This module depends on the following modules:

=over

=item *

Moose -- OOP framework (CPAN)

=item *

SIOC -- SIOC abstract base class (part of this module's distribution)

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
