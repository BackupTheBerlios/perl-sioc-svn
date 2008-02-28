###########################################################
# SIOC::Community
# Community class in the SIOC ontology
###########################################################
#
# $Id$
#

package SIOC::Community;

use strict;
use warnings;

use version; our $VERSION = qv(1.0.0);

use Moose;

extends 'SIOC';

1;
__END__
    
=head1 NAME

SIOC::Community -- SIOC Community class

=head1 VERSION

This documentation refers to SIOC::Community version 1.0.0.

=head1 SYNOPSIS

   use SIOC::Community;

=head1 DESCRIPTION

Community is a high-level concept that defines an online community and what it
consists of.

A Community may consist of different types of objects (people, sites, etc.)
joined by a common topic, interests or goals.

A Community is different from a Site: a Site describes a single community site
whilst a Community can consist of a number of Sites and other resources
described in SIOC or other ontologies (e.g., FOAF). Community is linked to its
constituent parts using the property dcterms:hasPart.


=head1 SUBROUTINES/METHODS

This class has no own methods.

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

SIOC -- Abstract base class (part of this module's distribution)

=back

=head1 INCOMPATIBILITIES

There are no known incompatibilities.

=head1 BUGS AND LIMITATIONS

There are no known bugs in this module.

Please report problems via the bug tracking system on the perl-SIOC project
website: L<http://developer.berlios.de/project/perl-SIOC>.

Patches are welcome.

=head1 AUTHOR

Jochen Lillich <geewiz@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2008 Jochen Lillich <geewiz@cpan.org>
All rights reserved.

This module is free software; it is distributed under the BSD license.
# TODO: Add BSD license site URL

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.
