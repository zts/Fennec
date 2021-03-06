#!/usr/bin/perl;
package TEST::StandaloneCore;
use strict;
use warnings;
use Fennec::Standalone;

tests hello_world_group => sub {
    my $self = shift;
    ok( 1, "Hello world" );
};

done_testing;

1;

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Fennec is free software; Standard perl licence.

Fennec is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.
