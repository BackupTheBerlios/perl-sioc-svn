###########################################################
# SIOC::User
# User class for the SIOC ontology
###########################################################
#
# $Id$
#

package SIOC::User;
use base qw( SIOC );

use strict;
use warnings;

our $VERSION = do { if (q$Revision$ =~ /Revision: (?:\d+)/mx) { sprintf "1.0-%03d", $1; }; };

{
    my %sioc_account_of :ATTR;
    my %sioc_administrator_of :ATTR;
    my %sioc_avatar :ATTR;
    my %sioc_creator_of :ATTR;
    my %sioc_email :ATTR;
    my %sioc_email_sha1 :ATTR;
    my %sioc_has_function :ATTR;
    my %sioc_member_of :ATTR;
    my %sioc_moderator_of :ATTR;
    my %sioc_modifier_of :ATTR;
    my %sioc_owner_of :ATTR;
    my %sioc_subscriber_of :ATTR;
}
1;
__END__
    
=head1 NAME

SIOC::User -- SIOC User class

=head1 VERSION

This documentation refers to SIOC::User version 0.0.1.

=head1 SYNOPSIS

   use SIOC::User;

   # Brief but working code example(s) here showing the most common usage(s)
   # This section will be as far as many users bother reading, so make it as
   # educational and exemplary as possible.

=head1 DESCRIPTION

A User is an online account of a member of an online community. It is
connected to Items and Posts that a User creates or edits, to Containers and
Forums that it is subscribed to or moderates and to Sites that it administers.
Users can be grouped for purposes of allowing access to certain Forums or
enhanced community site features (weblogs, webmail, etc.).

A foaf:Person will normally hold a registered User account on a Site (through
the property foaf:holdsAccount), and will use this account to create content
and interact with the community.

sioc:User describes properties of an online account, and is used in
combination with a foaf:Person (using the property sioc:account_of) which
describes information about the individual itself.

=head1 CLASS ATTRIBUTES

=over

=item account_of 

Refers to the foaf:Agent or foaf:Person who owns this sioc:User
online account.

=item administrator_of 

A Site that the User is an administrator of.

=item avatar 

An image or depiction used to represent this User.

=item creator_of 

An Item that the User is a creator of.

=item email 

An electronic mail address of the User.

=item email_sha1 

An electronic mail address of the User, encoded using SHA1.

=item has_function 

A Role that this User has.

=item member_of 

A Usergroup that this User is a member of.

=item moderator_of 

A Forum that User is a moderator of.

=item modifier_of 

An Item that this User has modified.

=item owner_of 

A Container owned by a particular User, for example, a weblog
or image gallery.

=item subscriber_of 

A Container that a User is subscribed to.

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