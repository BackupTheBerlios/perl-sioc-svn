###########################################################
# SIOC::Thread
# Thread class for the SIOC ontology
###########################################################
#
# $Id$
#

package SIOC::Thread;

use strict;
use warnings;

use version; our $VERSION = qv(1.0.0);

use Moose;

extends 'SIOC::Container';

### required attributes

has 'page' => (
    isa => 'Num',
    is => 'ro',
    required => 1,
    );

### methods

after 'fill_template' => sub {
    my ($self) = @_;
    
    $self->set_template_var(page => $self->page);
};

1;
__DATA__
__rdfoutput__
<sioc:Thread rdf:about="[% url | url %]">
    <sioc:link rdf:resource="[% url | url %]"/>
[% IF views %]
    <sioc:num_views>[% views %]</sioc:num_views>
[% END %]
[% IF note %]
    <rdfs:comment>[% note %]</rdfs:comment>
[% END %]
[% FOREACH topic = topics %]
    <sioc:topic>[% topic %]</sioc:topic>
[% END %]
[% FOREACH post = items %]
    <sioc:container_of>
        <sioc:Post rdf:about="[% post.url | url %]">
            <rdfs:seeAlso rdf:resource="[% siocURL('post', post.id) %]"/>
[% IF post.prev_by_date %]
		    <sioc:previous_by_date rdf:resource="[% post.prev_by_date | url %]"/>
[% END %]
[% IF post.next_by_date %]
		    <sioc:next_by_date rdf:resource="[% post.next_by_date | url %]"/>
[% END %]
        </sioc:Post>
    </sioc:container_of>
[% END %]
[% IF next %]
    <rdfs:seeAlso rdf:resource="[% siocURL('thread', id, page+1) %]"/>
[% END %]
</sioc:Thread>
__END__
    
=head1 NAME

SIOC::Thread -- SIOC Thread class

=head1 VERSION

The initial template usually just has:

This documentation refers to SIOC::Thread version 0.0.1.

=head1 SYNOPSIS

   use SIOC::Thread;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.

=head1 DESCRIPTION

Mailing lists, forums and blogs on community sites usually employ some
threaded discussion methods, whereby discussions are initialised by a certain
user and replied to by others. The Thread container is used to group Posts
from a single discussion thread together via the sioc:container_of property,
especially where a sioc:has_reply / reply_of structure is absent.

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
