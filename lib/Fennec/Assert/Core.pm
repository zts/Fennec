package Fennec::Assert::Core;
use strict;
use warnings;

our @CORE_LIST = qw/Simple More Exception Warn Anonclass/;

sub export_to {
    my $class = shift;
    my ( $dest, $prefix ) = @_;
    for my $item ( map { 'Fennec::Assert::Core::' . $_ } @CORE_LIST ) {
        eval "require $item; 1" || die ($@);
        $item->export_to( $dest, $prefix );
    }
}

sub import {
    my $class = shift;
    my ( $prefix ) = @_;
    my $caller = caller;
    $class->export_to( $caller, $prefix );
}

1;