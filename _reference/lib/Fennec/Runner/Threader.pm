package Fennec::Runner::Threader;
use strict;
use warnings;
use Fennec::Util qw/add_accessors/;
use POSIX ();
use Time::HiRes;
use base 'Exporter';

add_accessors qw/max pids/;

sub new {
    my $class = shift;
    my %proto = @_;
    $proto{ pid } = $$;

    return bless(
        {
            pids => [],
            max => 1,
            %proto,
        },
        $class
    );
}

sub thread {
    my $self = shift;
    my ( $code, $force_fork, @args ) = @_;
    $force_fork = 0 if $self->max > 1;

    return $self->_fork( $code, $force_fork, \@args )
        if $force_fork || $self->max > 1;

    return $code->( @args );
}

sub _fork {
    my $self = shift;
    my ( $code, $forced, $args ) = @_;

    # This will block if necessary
    my $tid = $self->get_tid
        unless $forced;

    my $pid = fork();
    if ( $pid ) {
        return $self->tid_pid( $tid, $pid )
            unless $forced;

        until ( waitpid( $pid, &POSIX::WNOHANG )) {
            Fennec::Runner->get->listener->iteration;
            sleep(0.10);
        }
        return;
    }

    # Make sure this new process does not wait on the previous process's children.
    $self->{pids} = [];

    $code->( @$args );
    $self->cleanup;
    Fennec::Runner->get->_sub_process_exit;
}

sub get_tid {
    my $self = shift;
    my $existing = $self->pids;
    while ( 1 ) {
        for my $i ( 1 .. $self->max ) {
            if ( my $pid = $existing->[$i] ) {
                my $out = waitpid( $pid, &POSIX::WNOHANG );
                $existing->[$i] = undef
                    if ( $pid == $out || $out < 0 );
            }
            return $i unless $existing->[$i];
        }
        sleep 1;
    }
}

# Get or set the pid for a tid.
sub tid_pid {
    my $self = shift;
    my ( $tid, $pid ) = @_;
    $self->pids->[$tid] = $pid if $pid;
    return $self->pids->[$tid];
}

sub cleanup {
    my $self = shift;
    for my $pid ( $self->pids ) {
        next unless $pid;
        waitpid( $pid, 0 );
    }
}

sub DESTROY {
    my $self = shift;
    return $self->cleanup;
}

1;