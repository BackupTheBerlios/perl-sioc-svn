###########################################################
# SIOC::Space
# Space class for the SIOC ontology
###########################################################
#
# $Id$
#
package SIOC::Space;

use strict;
use warnings;

our $VERSION = do { if (q$Revision$ =~ /Revision: (?:\d+)/mx) { sprintf "1.0-%03d", $1; }; };

use Moose;
use MooseX::AttributeHelpers;

extends 'SIOC';

### optional attributes

# Space which this resource is a part of
has 'parent' => (
    isa => 'SIOC::Space',
    is => 'rw',
);

# Resources which belong to this Space
has 'space_of' => (
    metaclass => 'Collection::Array',
    is => 'rw',
    isa => 'ArrayRef[SIOC]',
    default => sub { [] },
    provides => {
        'push' => 'make_space_of',
    },
);

# Usergroups that have certain access to this Space
has 'usergroups' => (
    isa => 'ArrayRef[SIOC::Usergroup]',
    metaclass => 'Collection::Array',
    is => 'rw',
    default => sub { [] },
    provides => {
        'push' => 'add_usergroups',
    },
);

### methods

after 'fill_template' => sub {
    my ($self) = @_;
    
    $self->set_template_var(parent => $self->parent);
    $self->set_template_var(usergroups => $self->usergroups);
    $self->set_template_var(space_of => $self->space_of);
};

1;
__END__

=head1 NAME

SIOC::Space -- SIOC Space class

=head1 VERSION

This documentation refers to SIOC::Space version 0.0.1.

=head1 SYNOPSIS

   use <Module::Name>;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.

=head1 DESCRIPTION

A Space is defined as being a place where data resides. It can be the location
for a set of Containers of content Items, e.g., on a Site, personal desktop,
shared filespace, etc. Any data object that resides on a particular Space can
be linked to it using the sioc:has_space property.

=head1 CLASS ATTRIBUTES

=over

=item has_usergroup 

Points to a Usergroup that has certain access to this
Space.

=item has_space 

A data Space which this resource is a part of.

=item space_of 

A resource which belongs to this data Space.

=back

=head1 SUBROUTINES/METHODS

=head2 add_usergroup

Adds a SIOC::Usergroup object to the list of usergroups defined in that space.

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
