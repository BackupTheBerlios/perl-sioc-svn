###########################################################
# SIOC::Site
# Site class for the SIOC ontology
###########################################################
#
# $Id$
#

package SIOC::Site;
use base qw( SIOC::Space );

use strict;
use warnings;

use Readonly;

use version; our $VERSION = qv(1.0.0);

{
    my %administrators :ATTR( :get<administrators>, :default([]) );
    my %forums :ATTR( :get<forums>, :default([]) );

    my %authors_usergroup :ATTR( :name<authors_usergroup>, :default('authors') );
    
    sub add_forum {
        my ($self, $forum) = @_;
        
        push @{$forums{ident $self}}, $forum;
        return 1;
    }
    
    sub add_administrator {
        my ($self, $admin) = @_;
       
        push @{$administrators{ident $self}}, $admin;
        return 1;
    }
    
    sub _set_template_vars {
        my ($self, $vars) = @_;

        $self->SUPER::_set_template_vars($vars);
        $vars->{forums} = $self->get_forums();
        $vars->{authors_ug} = $self->get_authors_usergroup();
        return $vars;
    }
    
}

1;
__DATA__
__rdfoutput__
<sioc:Site rdf:about="[% url %]">
    <dc:title>[% title %]</dc:title>
    <dc:description>[% description %]</dc:description>
    <sioc:link rdf:resource="[% url %]"/>
[% FOREACH forum = forums %]
    <sioc:host_of rdf:resource="[% forum.get_export_url %]"/>
[% END %]
    <sioc:has_Usergroup rdf:nodeID="[% authors_ug %]"/>
</sioc:Site>

[% FOREACH forum = forums %]
<sioc:Forum rdf:about="[% forum.get_url %]">
    <sioc:link rdf:resource="[% forum.get_url %]"/>
    <rdfs:seeAlso rdf:resource="[% forum.get_export_url %]"/>
</sioc:Forum>
[% END %]

[% IF users %]
<sioc:Usergroup rdf:nodeID="[% authors_ug %]">
    <sioc:name>Authors for "[% name %]"</sioc:name>
[% FOREACH user = users %]
    <sioc:has_member>
        <sioc:User rdf:about="[% user.get_url %]">
            <rdfs:seeAlso rdf:resource="[% user.get_export_url %]"/>
        </sioc:User>
    </sioc:has_member>
[% END %]
</sioc:Usergroup>
[% END %]
__END__
    
=head1 NAME

SIOC::Site - SIOC Site class

=head1 VERSION

This documentation refers to SIOC::Site version 0.0.1.

=head1 SYNOPSIS

   use SIOC::Site;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.

=head1 DESCRIPTION

A Site is the location of an online community or set of communities, with
Users in Usergroups creating content therein. While an individual Forum or
group of Forums are usually hosted on a centralised Site, in the future the
concept of a "site" may be extended (for example, a topic Thread could be
formed by Posts in a distributed Forum on a peer-to-peer environment Space).

=head1 CLASS ATTRIBUTES

=over

=item has_administrator 

A User who is an administrator of this Site.

=item host_of 

A Forum that is hosted on this Site.

=back


=head1 SUBROUTINES/METHODS

=head2 add_administrator

Add a SIOC::User object to the list of administrators.

=head2 add_forum

Add a SIOC::Forum object to the list of forums.

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

Jochen Lillich <geewiz at cpan.org>

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
