###########################################################
# SIOC::Post
# Post class for the SIOC ontology
###########################################################
#
# $Id$
#

package SIOC::Post;

use strict;
use warnings;

use version; our $VERSION = qv(1.0.0);

use Moose;
use MooseX::AttributeHelpers;

extends 'SIOC::Item';

### required attributes

has 'content' => (
    isa => 'Str',
    is => 'rw',
    required => 1,
    );
has 'encoded_content' => (
    isa => 'Str',
    is => 'rw',
    required => 1,
    );

### optional attributes

has 'attachments' => (
    isa => 'HashRef[Str]',
    metaclass => 'Collection::Hash',
    is => 'rw',
    default => sub { {} },
    );
has 'related_to' => (
    isa => 'ArrayRef[SIOC::Item]',
    metaclass => 'Collection::Array',
    is => 'rw',
    default => sub { [] },
    );
has 'siblings' => (
    isa => 'ArrayRef[SIOC::Item]',
    metaclass => 'Collection::Array',
    is => 'rw',
    default => sub { [] },
    );

### methods

after 'fill_template' => sub {
    my ($self) = @_;
    
    $self->set_template_var(content => $self->content);
    $self->set_template_var(encoded_content => $self->encoded_content);
};

1;

__DATA__
__rdf_output__
<sioc:Post rdf:about="[% url | url %]">
[% IF title %]
    <dc:title>[% title %]</dc:title>
[% END %]
[% IF creator %]
    [% IF creator.id %]
    <sioc:has_creator>
        <sioc:User rdf:about="[% creator.url | url %]">
            <rdfs:seeAlso rdf:resource="[% siocURL('user', creator.id) %]"/>
        </sioc:User>
    </sioc:has_creator>
    <foaf:maker>
        <foaf:Person rdf:about="[% creator.foaf_uri | url %]">
            <rdfs:seeAlso rdf:resource="[% siocURL('user', creator.id) %]"/>
        </foaf:Person>
    </foaf:maker>
    [% ELSE %]
    <foaf:maker>
        <foaf:Person
        [% IF creator.name %]
            foaf:name="[% creator.name %]"
        [% END %]
        [% IF creator.sha1 %]
            foaf:mbox_sha1sum="[% creator.sha1 %]"
        [% END %]
        [% IF creator.homepage %]
        >
            <foaf:homepage rdf:resource="[% creator.homepage | url %]"/>
        </foaf:Person>
        [% ELSE %]
        />
        [% END %]
    </foaf:maker>
    [% END %]

    <dcterms:created>[% created %]</dcterms:created>
    [% IF updated && created != updated %]
    <dcterms:modified>[% modified %]</dcterms:modified>
    [% END %]

    <sioc:content>[% content %]</sioc:content>
    <content:encoded><![CDATA[[% content_encoded %]]]></content:encoded>
    
    [% FOREACH topic = topics %]
    <sioc:topic rdfs:label="[% topic.name %]" rdf:resource="[% topic.url | url %]"/>
    [% END %]

    [% FOREACH link = links %]
    <sioc:links_to rdfs:label="[% link.name %]" rdf:resource="[% link.url | url %]"/>
    [% END %]
    
    [% FOREACH parent = parents %]
    <sioc:reply_of>
        <sioc:Post rdf:about="[% parent.url | url %]">
            <rdfs:seeAlso rdf:resource="[% siocURL('post', parent.id) %]"/>
        </sioc:Post>
    </sioc:reply_of>
    [% END %]
    
    [% FOREACH reply = replies %]
    <sioc:has_reply>
        <sioc:Post rdf:about="[% reply.url | url %]">
            <rdfs:seeAlso rdf:resource="[% siocURL('comment', reply.id) %]"/>
        </sioc:Post>
    </sioc:has_reply>
    [% END %]
    
</sioc:Post>
__END__
    
=head1 NAME

SIOC::Post - SIOC Post class

=head1 VERSION

The initial template usually just has:

This documentation refers to <Module::Name> version 0.0.1.

=head1 SYNOPSIS

   use <Module::Name>;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.

=head1 DESCRIPTION

A Post is an article or message posted by a User to a Forum. A series of Posts
may be threaded if they share a common subject and are connected by reply or
by date relationships. Posts will have content and may also have attached
files, which can be edited or deleted by the Moderator of the Forum that
contains the Post.

The SIOC Types Ontology Module describes some additional, more specific
subclasses of SIOC::Post.

=head2 Class attributes

=over

=item attachment 

The URI of a file attached to a Post.

=item content 

The content of the Post in plain text format.

=item note 

A note associated with this Post, for example, if it has been
edited by a User.

=item num_replies 

The number of replies that this Post has. Useful for when
the reply structure is absent.

=item related_to 

Related Posts for this Post, perhaps determined implicitly
from topics or references.

=item sibling 

A Post may have a sibling or a twin that exists in a different
Forum, but the siblings may differ in some small way (for example, language,
category, etc.). The sibling of this Post should be self-describing (that is,
it should contain all available information).

=item content_encoded 

Used to describe the encoded content of a Post, contained in CDATA areas.

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
