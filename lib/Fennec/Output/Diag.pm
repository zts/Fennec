package Fennec::Output::Diag;
use strict;
use warnings;

use base 'Fennec::Output';

sub new {
    my $class = shift;
    return bless( { @_ }, $class );
}

1;

=head1 NAME

Fennec::Output::Diag - Represents a diagnostics output object.

=head1 DESCRIPTION

See L<Fennec::Output>

=head1 SYNOPSIS

    use Fennec::Output::Diag;
    $diag = Fennec::Output::Diag->new( stderr => \@messages );

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Fennec is free software; Standard perl licence.

Fennec is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.
