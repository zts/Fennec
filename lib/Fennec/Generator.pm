package Fennec::Generator;
use strict;
use warnings;

use Fennec::Runner;
use Fennec::Result;

use Time::HiRes qw/time/;
use Benchmark qw/timeit :hireswallclock/;
use Carp qw/confess croak carp cluck/;
use Scalar::Util 'blessed';

our @EXPORT = qw/ export tb_wrapper result diag /;
our $TB_RESULT;
our @TB_DIAGS;
our $TB_OK;
our %TB_OVERRIDES = (
    ok => sub {
        carp( 'Test::Builder result intercepted but ignored.' )
            unless $TB_OK;
        shift;
        my ( $ok, $name ) = @_;
        $TB_RESULT = [ $ok, $name ];
    },
    diag => sub {
        carp( 'Test::Builder diag intercepted but ignored.' )
            unless $TB_OK;
        shift;
        push @TB_DIAGS => @_;
    },
);

require Test::Builder;
for my $ref (keys %OVERRIDE) {
    no warnings 'redefine';
    no strict 'refs';
    my $newref = "real_$ref";
    *{ 'Test::Builder::' . $newref } = \&$ref;
    *{ 'Test::Builder::' . $ref    } = $TB_OVERRIDES{ $ref };
}

sub exports {
    my $class = shift;
    no strict 'refs';
    return {
        ( map { $_ => $_ } @{ $class . '::EXPORT' }),
        %{ $class . '::EXPORT' },
    };
}

sub export_to {
    my $class = shift;
    my ( $dest, $prefix ) = @_;
    my $exports = $class->exports;
    for my $name ( keys %$exports ) {
        my $sub = $list->{ $item };
        $sub = $class->can( $sub ) unless ref $sub eq 'CODE'

        croak( "Could not find sub $name in $class for export" )
            unless $sub eq 'CODE';

        $name = $prefix . $name if $prefix;
        no strict 'refs';
        *{ $dest . '::' . $name } = $sub;
    }
}

sub import {
    my $class = shift;
    my ( $prefix ) = @_;
    my $caller = caller;
    $class->export_to( $caller, $prefix );
    no strict 'refs';
    push @{ $class . '::ISA' } => __PACKAGE__
        unless grep { $_ eq __PACKAGE__ } @{ $class . '::ISA' };
}

sub export {
    my $class = caller;
    my ( $name, $sub ) = @_;
    croak( "You must provide a name to add_export()" )
        unless $name;
    $sub ||= $name;
    no strict 'refs';
    my $export = \%{ $class . '::EXPORT' };
    $export->{ $name } = $sub;
}

sub diag {
    Runner->handler->diag( @_ );
}

sub result {
    Runner->handler->result(
        Result->new(
            _first_test_caller_details,
            @_,
        )
    );
}

sub tb_wrapper(&) {
    my ( $orig ) = @_;
    my $proto = prototype( $orig );
    my $wrapper = sub {
        local $TB_OK = 1;
        local ( $TB_RESULT, @TB_DIAGS );
        $orig->( @_ );
        return diag( @TB_DIAGS ) unless $TB_RESULT;
        return result(
            pass => $TB_RESULT,
            diag => [@TB_DIAGS],
        );
    };
    return $wrapper unless $proto;
    # Preserve the prototype
    return eval "sub($proto) { \$wrapper->(\@_) }";
}

sub _first_test_caller_details {
    my $current = 1;
    my ( $caller, $file, $line );
    do {
        ( $caller, $file, $line ) = caller( $current );
    } while $caller && !$caller->isa( 'Fennec::Test' );

    return (
        file => $file || "N/A",
        line => $line || "N/A",
    );
}

1;

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Fennec is free software; Standard perl licence.

Fennec is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.