###########################################################
# SIOC::Role
# Role class for the SIOC ontology
###########################################################
#
# $Id$
#

package SIOC::Role;

use strict;
use warnings;

use version; our $VERSION = qv(1.0.0);

use Moose;

extends 'SIOC';

### optional attributes

has 'owner' => (
    isa => 'SIOC::User',
    is => 'rw',
);

has 'scope' => (
    isa => 'SIOC::Forum',
    is => 'rw',
);

### methods

after '_fill_template' => sub {
    my ($self) = @_;
    
    $self->set_template_vars({
        function_of => $self->function_of,
        scope => $self->scope
    });
};

### EOC

1;
__END__
    
=head1 NAME

SIOC::Role -- SIOC Role class

=head1 VERSION

This documentation refers to SIOC::Role version 1.0.0.

=head1 SYNOPSIS

   use SIOC::Role;

=head1 DESCRIPTION

Roles are used to express functions or access control privileges that Users
may have.

=head1 CLASS ATTRIBUTES

=over

=item owner 

A User who has this Role.

=item scope 

Forums that this Role applies to.

=back


=head1 SUBROUTINES/METHODS

=head2 owner([$user])

Accessor for the attribute of the same name. Call without argument to read the current value of the attribute; sets attribute when called with new value as argument.

=head2 scope([$forum])

Accessor for the attribute of the same name. Call without argument to read the current value of the attribute; sets attribute when called with new value as argument.


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

There are no known incompatibilities.

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

Please report problems via the bug tracking system on the perl-SIOC project
website: L<http://developer.berlios.de/projects/perl-sioc/>.

Patches are welcome.

=head1 AUTHOR

Jochen Lillich <geewiz@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2008, Jochen Lillich, Socialware.at
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.

    * Neither the name of Socialware nor the names of its contributors may not
      be used to endorse or promote products derived from this software
      without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.