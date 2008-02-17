###########################################################
# SIOC::Forum
# Forum class for the SIOC ontology
###########################################################
#
# $Id$
#

package SIOC::Forum;

use strict;
use warnings;

use version; our $VERSION = qv(1.0.0);

use Moose;
use MooseX::AttributeHelpers;

extends 'SIOC::Container';

### optional attributes

has 'host' => (
    isa => 'SIOC::Site',
    is => 'rw'
    );

has 'moderator' => (
    isa => 'SIOC::User',
    is => 'rw',
    );

has 'scope_of' => (
    isa => 'ArrayRef[SIOC::Role]',
    metaclass => 'Collection::Array',
    is => 'rw',
    default => sub { [] },
    );

### methods

after 'fill_template' => sub {
    my ($self) = @_;
    
    $self->set_template_var(host => $self->host);
    $self->set_template_var(moderator => $self->moderator);
    $self->set_template_var(scope_of => $self->scope_of);
};

1;
__DATA__
__rdfoutput__
<sioc:Forum rdf:about="[% url %]">
    <sioc:link rdf:resource="[% export_url %]"/>
[% IF title %]
    <dc:title>[% title %]</dc:title>
[% END %]
[% IF description %]
    <dc:description>[% description %]</dc:description>
[% END %]
[% IF comment %]
    <rdfs:comment>[% comment %]</rdfs:comment>
[% END %]

[% FOREACH thread = threads %]
    <sioc:parent_of>
        <sioc:Thread rdf:about="[% thread.get_url %]">
            <rdfs:seeAlso rdf:resource="[% thread.get_export_url %]"/>
        </sioc:Thread>
    </sioc:parent_of>
[% END %]

[% FOREACH post = posts %]
    <sioc:container_of>
        <sioc:Post rdf:about="[% post.get_url %]">
            <rdfs:seeAlso rdf:resource="[% post.get_sioc_url %]"/>
        </sioc:Post>
    </sioc:container_of>
[% END %]

[% IF next_page_url %]
    <rdfs:seeAlso rdf:resource="[% next_page_url %]"/>
[% END %]
</sioc:Forum>
__END__
    
=head1 NAME

SIOC::Forum -- SIOC Forum class

=head1 VERSION

The initial template usually just has:

This documentation refers to <Module::Name> version 0.0.1.

=head1 SYNOPSIS

   use <Module::Name>;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.

=head1 DESCRIPTION

Forums can be thought of as channels or discussion area on which Posts are
made. A Forum can be linked to the Site that hosts it. Forums will usually
discuss a certain topic or set of related topics, or they may contain
discussions entirely devoted to a certain community group or organisation. A
Forum will have a moderator who can veto or edit posts before or after they
appear in the Forum.

Forums may have a set of subscribed Users who are notified when new Posts are
made. The hierarchy of Forums can be defined in terms of parents and children,
allowing the creation of structures conforming to topic categories as defined
by the Site administrator. Examples of Forums include mailing lists, message
boards, Usenet newsgroups and weblogs.

The SIOC Types Ontology Module defines come more specific subclasses of
SIOC::Forum.

=head1 CLASS ATTRIBUTES

=over

=item has_host 

The Site that hosts this Forum.

=item has_moderator 

A User who is a moderator of this Forum.

=item scope_of 

A Role that has a scope of this Forum.

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