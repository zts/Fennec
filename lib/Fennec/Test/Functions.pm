package Fennec::Test::Functions;
use strict;
use warnings;
use Carp;
use Fennec::Util qw/get_all_subs/;

sub export_to {
    my $class = shift;
    my ( $package ) = @_;
    return 1 unless $package;

    my @subs = get_all_subs($class);
    for my $sub ( @subs ) {
        no strict 'refs';
        *{ $package . '::' . $sub } = \&$sub;
    }
}

#XXX These 2 functions are almost identical, can we abstract this?

sub test_set {
    my $name = shift;
    croak( "You must provide a set name, and it must not be a reference" )
        if !$name || ref $name;

    my $code = shift if @_ == 1;
    my ( $package, $filename, $line ) = caller;
    my %proto = ( method => $code, @_, test => $package, filename => $filename, line => $line );

    $package->add_set( $name, %proto );
}

sub test_case {
    my $name = shift;
    croak( "You must provide a case name, and it must not be a reference" )
        if !$name || ref $name;

    my $code = shift if @_ == 1;
    my ( $package, $filename, $line ) = caller;
    my %proto = ( method => $code, @_, test => $package, filename => $filename, line => $line );

    $package->add_case( $name, %proto );
}

sub describe {
    my ( $name, $code ) = @_;
}

sub it {
    croak( "It does not point to the proper real_it yet" );
    goto @it_once;
}

sub it_once {
    my ( $name, $code ) = @_;

}

sub it_each {
    my ( $name, $code ) = @_;

}

sub before_each(&) {
    my ( $code ) = @_;

}

sub after_each(&) {
    my ( $code ) = @_;

}

sub before_all(&) {
    my ( $code ) = @_;

}

sub after_all(&) {
    my ( $code ) = @_;

}

sub setup(&) {
    my ( $code ) = @_;

}

sub teardown(&) {
    my ( $code ) = @_;

}

sub bail_out {
    my ( $reason ) = @_;
}

1;

=pod

=head1 NAME

Fennec::Test::Functions - Functions for creating/manipulating cases and sets.

=head1 DESCRIPTION

This package is repsonsible for the case/set creation functionality. You will
probably never need to use this directly.

=head1 EARLY VERSION WARNING

This is VERY early version. Fennec does not run yet.

Please go to L<http://github.com/exodist/Fennec> to see the latest and
greatest.

=head1 CLASS METHODS

=over 4

=item $class->export_to( $package )

Export all functions to the specified package.

=back

=head1 EXPORTABLE FUNCTIONS

=over 4

=item test_set( $name, $code )

=item test_set( $name, %proto )

Define a test set in the calling test class.

=item test_case( $name, $code )

=item test_case( $name, %proto )

Define a test case in the calling test class.

=back

=head1 AUTHORS

Chad Granum L<exodist7@gmail.com>

=head1 COPYRIGHT

Copyright (C) 2010 Chad Granum

Fennec is free software; Standard perl licence.

Fennec is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE.  See the license for more details.
