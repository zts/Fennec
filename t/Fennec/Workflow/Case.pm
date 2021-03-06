package TEST::Fennec::Workflow::Case;
use strict;
use warnings;

use Fennec workflows => [ 'Case' ],
           sort => 1,
           no_fork => 1;

use Fennec::Util::Accessors;

Accessors qw/ state /;

sub init {
    my $self = shift;
    $self->state({});
}

cases 'a - first' => sub {
    my $self = shift;

    case 'case a' => sub {
        my $self = shift;
        $self->state->{cases}->{a}++
    };
    case 'case b' => sub {
        my $self = shift;
        $self->state->{cases}->{b}++
    };
    case 'case c' => sub {
        my $self = shift;
        $self->state->{cases}->{c}++
    };

    tests 'tests a' => sub {
        my $self = shift;
        $self->state->{sets}->{a}++
    };
    tests 'tests b' => sub {
        my $self = shift;
        $self->state->{sets}->{b}++
    };
    tests 'tests c' => sub {
        my $self = shift;
        $self->state->{sets}->{c}++
    };
};

tests 'z - Run this last' => sub {
    my $self = shift;
    is_deeply(
        $self->state,
        {
            cases => {
                a => 3,
                b => 3,
                c => 3,
            },
            sets => {
                a => 3,
                b => 3,
                c => 3,
            },
        },
        "3 sets x 3 cases, all run 3 times"
    );
};

1;

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Fennec is free software; Standard perl licence.

Fennec is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.
